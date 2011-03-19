My iOS mock object needs can no longer met by OCMock:

* My tests were brittle because OCMock is a record-and-playback system, quite
  strict by default. Adding new calls to helper objects broke my tests. Fixing
  these tests by changing the mocks to "nice" mocks meant I had to explicitly
  reject calls.
* While OCMock supports OCHamcrest matchers, this exchange triggers compiler
  warnings.
* Due to a long-standing bug in the iOS simulator, an unexpected call (or an
  explicitly rejected call) crashes the entire test system. This is no fault of
  OCMock, which is just raising an exception. But because the exception can't be
  caught by unit testing frameworks, the resulting crash renders this vital
  feature of OCMock useless.

OCHandMock is an iOS port of a small subset of jMock in its early days, designed
to address my problems:

* I guess I still prefer hand-coding my mock objects. jMock started as a
  framework to support hand-rolled mocks.
* OCHamcrest is a first-class partner of OCHandMock. Mock methods can record and
  verify their invocations with just two classes: one that verifies invocation
  count, and another that verifies arguments using any OCHamcrest-compatible
  matcher.
* OCHandMock works around the iOS simulator bug. Instead of raising an
  exception, it signals the test failure directly to your OCUnit-compatible test
  case object, which can then report it to Xcode.
