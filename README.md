Introduction
============

My iOS mock object needs can no longer met by OCMock:

* My tests were fragile. Because OCMock is a record-and-playback system, tests
  broke whenever anybody added a single new call to a helper object. This led
  some to question the usefulness of unit testing. (The workaround is to use
  "nice" mocks everywhere.)
* Some tests set up a fair number of mocks to show which ones get called.
  Calling `-verify` on each mock object at the end of each test is tedious.
* While OCMock supports OCHamcrest matchers, this triggers compiler warnings.
* Due to a long-standing bug in the iOS simulator, an unexpected call (or an
  explicitly rejected call) crashes the entire test system. This is no fault of
  OCMock, which is just raising an exception. But because the exception can't be
  caught by unit testing frameworks, the resulting crash renders this vital
  feature of OCMock useless and impedes test-driven development.

**OCHandMock** is an iOS port of a small subset of jMock in its early days,
designed to address my problems:

* I guess I still prefer hand-coding my mock objects, using Subclass and
  Override. jMock's early architecture helps.
* OCHandMock can verify all mock objects in a test case with a single call.
* OCHandMock treats [OCHamcrest](https://github.com/jonreid/OCHamcrest) as a
  first-class partner. Mock methods can record and verify their invocations with
  just two classes: one to verify invocation count, and another to verify
  arguments using any OCHamcrest-compatible matchers.
* OCHandMock works around the iOS simulator bug: Instead of raising exceptions,
  it signals failures directly to your OCUnit test cases. Failures show up as
  Xcode errors, and the remaining tests are executed.


Example: Mock within fixture
============================

Let's say we have a class Foo and want to mock a replacement for it. The method
we want to mock is `-foo:` and it takes an `id` argument. The class interface
might look like this:

    @interface MockFoo : Foo <HMVerifiable>
    @property(nonatomic, retain) HMExpectationCounter *counter;
    @property(nonatomic, retain) HMExpectationMatcher *arg;
    @end

We declare that our mock class conforms to `HMVerifiable`. This simply means
that it will provide a `-verify` method.

The first property is a counter, to count the number of times the method is
invoked. The second property is a matcher, allowing us to specify our
expectations of the method argument using OCHamcrest.

Let's go on to the implementation.

    @implementation MockFoo

    @synthesize counter;
    @synthesize arg;

    - (id)initWithTestCase:(id)test
    {
        self = [super init];
        if (self)
        {
            counter = [[HMExpectationCounter alloc] initWithName:@"counter testCase:test];
            arg = [[HMExpectationMatcher alloc] initWithName:@"arg" testCase:test];
        }
        return self;
    }

    - (void)dealloc
    {
        [counter release];
        [arg release];

        [super dealloc];
    }

That sets up ordinary memory management of our properties. But notice that the
initializer takes a test case as an argument. This is passed on to each of the
expectations, so that failures can be reported back to the test without using
exceptions.

Here's the mock method:

    - (void)foo:(id)theArg
    {
        [counter increment];
        [arg setActual:theArg];
    }

It increments the invocation counter, and records the actual argument. Both are
expectations, and by default are immediately validated.

Finally, here's the `-verify` method:

    - (void)verify
    {
        [HMVerifier verify:self];
    }

    @end

This asks OCHandMock to verify all instance variables that are verifiable -- in
our case, the two expectations.

Now let's set up a test case that uses this mock object in its fixture. The test
case class is `HMTestCase` which inherits from OCUnit's `SenTestCase`.

    @interface TestInFixture : HMTestCase
    {
        MockFoo *mock;
    }
    @end

    @implementation TestInFixture

    - (void)setUp
    {
        [super setUp];
        mock = [[MockFoo alloc] initWithTestCase:self];
    }

    - (void)tearDown
    {
        [mock release];
        [super tearDown];
    }

Pretty straightforward. Now for the test. Let's set the expectation that `-foo`
will be invoked once, with the string "bar", and verify it:

    - (void)testFoo
    {
        [[mock counter] setExpected:1];
        [[mock arg] setExpected:is(@"bar")];

        // ...Do something here that should invoke [mock foo:@"bar"]

        [self verify];
    }

    @end

The OCHamcrest matcher `is(@"bar")` is an easy way to test for equality. You can
specify any matcher expression. Using less restrictive matchers will make your
tests less fragile.

Besides `-setExpected:`, you can also call `-setExpectNothing` to verify that
something _isn't_ invoked. And where no expectations are set, nothing is
demanded.

HMTestCase's `-verify` method verifies all instance variables in the test
fixture. ...Among other things, as we'll see in the second example.


Example: Mock within test method
================================

What if you don't want a mock to live in your fixture, but instead you want to create it on the fly in a single test method? Let's modify `MockFoo` to allow this.

First, life is easier with convenience methods:

    @interface MockFoo : Foo <HMVerifiable>
    // ...Same properties as before.
    - (id)initWithTestCase:(id)test;
    @end

    @implementation MockFoo

    + (id)mockWithTestCase:(id)test
    {
        return [[[self alloc] initWithTestCase:test] autorelease];
    }

Only one change is necessary to the initializer:

    - (id)initWithTestCase:(id)test
    {
        self = [super init];
        if (self)
        {
            [test registerVerifiable:self];
            // ...Same property initialization as before.
        }
        return self;
    }

`[test registerVerifiable:self]` is the glue that lets the HMTestCase know about the existence of this new verifiable object. So for a test class that doesn't have `MockFoo` in the fixture, here's the test method:

    - (void)testFoo
    {
        MockFoo *mock = [MockFoo mockWithTestCase:self];
        [[mock counter] setExpected:1];
        [[mock arg] setExpected:is(@"bar")];

        // ...Do something here that should invoke [mock foo:@"bar"]

        [self verify];
    }

HMTestCase's `-verify` method also verifies all objects that have been registered using `-registerVerifiable:`.
