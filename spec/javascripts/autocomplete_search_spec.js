//= require modules/autocomplete_search

describe("modules/autocomplete_search", function() {
  var module,
      sandbox = sinon.sandbox.create(),
      contextFake;

  beforeEach(function() {
    contextFake = new Box.TestServiceProvider({});
    contextFake.getElement = sandbox.stub().returns(null);
    module = Box.Application.getModuleForTest('autocomplete_search', contextFake);
  });

  afterEach(function() {
    sandbox.verifyAndRestore();
  });

  describe('init', function() {
    it('should call setup autocomplete', function() {
      var mock = sinon.mock(module);
      mock.expects('setup_autocomplete_public').once();
      mock.expects('setup_storage').once();
      
      module.init();
      mock.verify();
    });
  });
});
