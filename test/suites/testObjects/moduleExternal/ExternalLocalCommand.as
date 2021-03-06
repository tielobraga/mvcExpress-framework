package suites.testObjects.moduleExternal {
import mvcexpress.mvc.Command;

/**
 * CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org/)
 */
public class ExternalLocalCommand extends Command {

	[Inject]
	public var dataProxy:ExternalDataProxy;

	public function execute(blank:Object):void {
		dataProxy.localCommandCount++;
	}

}
}