//= require modules/click_bottle

function is_tablet_and_down() {
  return false;
}

describe("modules/click_bottle", function() {
  var module,           // Testable T3 module 
      sandbox,          // Sandbox of spies, stubs, and mocks
      elementFixture,   // Fixture for module DOM representation
      contextFake,      // Mocked T3 context for module
      cabinet_service;

  beforeEach(function() {
    elementFixture = fixture.load("shelf.html");
    sandbox = sinon.sandbox.create();
    cabinet_service = { 
      delete: function() { },
      update: function() { }
    };
    contextFake = new Box.TestServiceProvider({
      'cabinet-service': cabinet_service
    });
    sandbox.spy($.prototype, "tipso");
  });
  
  afterEach(function() {
    sandbox.verifyAndRestore();
  });
  
  describe('onclick', function() {
    beforeEach(function() {
      contextFake.getElement = sandbox.stub().returns(elementFixture);
      module = Box.Application.getModuleForTest('click-bottle', contextFake);
      module.init();
    });

    it('should delete clicked bottles', function() {
      sandbox.mock(cabinet_service).expects('delete').withArgs('Ibuprofen').once();
      var element = $('.clickable-pill-container')[0];
      var target = $('*[data-set-id="212"]')[0];
      var event = $.Event('click', { target: target });

      module.onclick(event, element, $(element).attr('data-type'));
    });

    it('should select the clicked bottle', function() {
      sandbox.mock(cabinet_service).expects('update').withArgs('Ibuprofen').once();
      var element = $('.clickable-pill-container')[0];
      var event = $.Event('click', { target: element });

      module.onclick(event, element, $(element).attr('data-type'));
    });
  });
});
