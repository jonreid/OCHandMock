My iOS mock object needs can no longer met by OCMock:

* My tests were fragile. Because OCMock is a record-and-playback system, tests
  broke whenever anybody added a single new call to a helper object. This led
  some to question the usefulness of unit testing. (The workaround is to use
  "nice" mocks.)
* Some tests set up a fair number of mocks to show which ones get called.
  Calling verify on each mock object at the end of each test became tedious.
* While OCMock supports OCHamcrest matchers, it triggers compiler warnings.
* Due to a long-standing bug in the iOS simulator, an unexpected call (or an
  explicitly rejected call) crashes the entire test system. This is no fault of
  OCMock, which is just raising an exception. But because the exception can't be
  caught by unit testing frameworks, the resulting crash renders this vital
  feature of OCMock useless and impedes test-driven development.

**OCHandMock** is an iOS port of a small subset of jMock in its early days,
designed to address my problems:

* I guess I still prefer hand-coding my mock objects, using Subclass and
  Override. jMock's early architecture helps.
* OCHandMock can verify all instance variables of a test case with one call.
* OCHandMock treats [OCHamcrest](https://github.com/jonreid/OCHamcrest) as a
  first-class partner. Mock methods can record and verify their invocations with
  just two classes: one to verify invocation count, and another to verify
  arguments using any OCHamcrest-compatible matchers.
* OCHandMock works around the iOS simulator bug: Instead of raising exceptions,
  it signals failures directly to your OCUnit-compatible test cases, which can
  report it to Xcode and continue the remaining tests.
