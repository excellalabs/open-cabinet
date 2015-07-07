//= require modules/autocomplete_search

describe("modules/autocomplete_search", function() {
  var module,           // Testable T3 module 
      sandbox,          // Sandbox of spies, stubs, and mocks
      elementFixture,   // Fixture for module DOM representation
      contextFake,      // Mocked T3 context for module
      cabinet_service;

  beforeEach(function() {
    elementFixture = fixture.load("autocomplete.html");
    sandbox = sinon.sandbox.create();
    cabinet_service = { 
      add: function() { }
    };
    contextFake = new Box.TestServiceProvider({
      'cabinet-service': cabinet_service
    });
    contextFake.getElement = sandbox.stub().returns(elementFixture);
    module = Box.Application.getModuleForTest('autocomplete_search', contextFake);
    sandbox.spy($.prototype, "typeahead");
    module.init();
  });
  
  afterEach(function() {
    sandbox.verifyAndRestore();
  });
  
  describe('onkeydown', function() {

    it('should show an error if the value does not exist in the autocomplete', function() {
      sandbox.stub(Bloodhound.prototype, "get").withArgs('IBUPROFEN').returns([]);
      var target = $('#search_input')[0];
      var event = $.Event('keydown', { target: target, keyCode: 13 });

      module.onkeydown(event, null, null);
      expect($('.error-message').text()).to.contain("Could not find results for 'Ibuprofen', please try again.");
    });

    it('should add the medicine if the value is in the autocomplete', function() {
      sandbox.stub(Bloodhound.prototype, "get").withArgs('IBUPROFEN').returns(['Ibuprofen']);
      sandbox.mock(cabinet_service).expects('add').withArgs('Ibuprofen').once();
      var target = $('#search_input')[0];
      var event = $.Event('keydown', { target: target, keyCode: 13 });

      module.onkeydown(event, null, null);
    });
  });
});
