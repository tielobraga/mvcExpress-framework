package integration.moduleInitTests.testObj {
import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.ProxyMap;
import mvcexpress.modules.ModuleCore;

/**
 * COMMENT : todo
 * @author mindscriptact
 */
public class InitTestModuleCore extends ModuleCore {

	static public const NAME:String = "InitTestModuleCore";

	public function InitTestModuleCore() {
		super(InitTestModuleCore.NAME);
	}

	override protected function onInit():void {

	}

	override protected function onDispose():void {

	}

	public function getProxyMap():ProxyMap {
		return proxyMap;
	}

	public function getCommandMap():CommandMap {
		return commandMap;
	}

	public function getMediatorMap():MediatorMap {
		return mediatorMap;
	}

}
}