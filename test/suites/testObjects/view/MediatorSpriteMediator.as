package suites.testObjects.view {
import flash.events.Event;

import mvcexpress.mvc.Mediator;

import suites.TestViewEvent;
import suites.testObjects.TestObject;

/**
 * COMMENT
 * @author
 */
public class MediatorSpriteMediator extends Mediator {

	static public var instance:MediatorSpriteMediator;

	[Inject]
	public var view:MediatorSprite;

	override protected function onRegister():void {

		addHandler("test_add_empty_handler", handleTestEmptyHandler);
		addHandler("test_handler_object_params", handleTestWithObjectParams);
		addHandler("test_handler_bad_params", handleTestWithBadParams);
		addHandler("test_handler_two_params", handleTestWithTwoParams);
		addHandler("test_handler_two_params_one_optional", handleTestWithTwoParamsOneOptional);

		view.addEventListener(TestViewEvent.TRIGER_ADD_HANDLER, addTestHandler);

		MediatorSpriteMediator.instance = this;
	}

	override protected function onRemove():void {
		MediatorSpriteMediator.instance = null;
	}

	private function addTestHandler(event:Event):void {
		addHandler("test", handleTestEmptyHandler);
	}

	public function handleTestEmptyHandler(params:Object):void {
		addHandler("test_empty_handler", handleTestEmpty);
	}

	public function handleTestEmpty():void {

	}

	public function handleTestWithObjectParams(params:Object):void {

	}

	public function handleTestWithBadParams(params:TestObject):void {

	}

	public function handleTestWithTwoParams(params:Object, extraParam:String):void {

	}

	public function handleTestWithTwoParamsOneOptional(params:Object, extraParam:String = null):void {

	}

	public function getIsReady():Boolean {
		return this.isReady;
	}

}
}