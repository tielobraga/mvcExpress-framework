package mvcexpress.core.lazy {
/**
 * private class to store lazy proxy data.
 * @private
 *
 * @version 2.0.rc1
 */
public class LazyProxyVO {

	public var proxyClass:Class;
	public var name:String;

	public var injectClass:Class;
	public var injectClassAndName:String;

	public var mediatorInjectClass:Class;
	public var mediatorInjectClassAndName:String;

	public var proxyParams:Array;
}
}
