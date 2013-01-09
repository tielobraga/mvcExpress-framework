package com.mindScriptAct.mvcExpressLiveVisualizer.view {
import com.mindScriptAct.mvcExpressLiveVisualizer.messages.VizualizerMessage;
import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rBanevicius
 */
public class ColorControlMediator extends Mediator {
	
	[Inject]
	public var view:ColorControls;
	
	//[Inject]
	//public var myProxy:MyProxy;
	
	override public function onRegister():void {
		trace("ColorControlMediator.onRegister", view.colorId);
		
		view.addEventListener(ColorControlEvent.ADD, handleAdd);
		view.addEventListener(ColorControlEvent.REMOVE, handleRemove);
	}
	
	private function handleRemove(event:ColorControlEvent):void {
		//trace("ColorControlMediator.handleRemove > event : " + event.colorId);
		sendMessage(VizualizerMessage.ADD, view.taskClass);
	}
	
	private function handleAdd(event:ColorControlEvent):void {
		//trace("ColorControlMediator.handleAdd > event : " + event.colorId);
		sendMessage(VizualizerMessage.REMOVE, view.taskClass);
	}
	
	override public function onRemove():void {
	
	}

}
}