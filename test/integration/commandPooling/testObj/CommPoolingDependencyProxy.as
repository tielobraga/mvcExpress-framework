package integration.commandPooling.testObj {
import mvcexpress.mvc.Proxy;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class CommPoolingDependencyProxy extends Proxy {
	private var _proxyName:String;

	public function CommPoolingDependencyProxy(proxyName:String = "undefined") {
		this._proxyName = proxyName;

	}

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}

	public function get proxyName():String {
		return _proxyName;
	}

}
}