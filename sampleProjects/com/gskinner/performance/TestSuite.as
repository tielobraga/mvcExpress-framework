﻿/** * TestSuite by Grant Skinner. Feb 1, 2010 * Visit www.gskinner.com/blog for documentation, updates and more free code. * * * Copyright (c) 2010 Grant Skinner * * Permission is hereby granted, free of charge, to any person * obtaining a copy of this software and associated documentation * files (the "Software"), to deal in the Software without * restriction, including without limitation the rights to use, * copy, modify, merge, publish, distribute, sublicense, and/or sell * copies of the Software, and to permit persons to whom the * Software is furnished to do so, subject to the following * conditions: * * The above copyright notice and this permission notice shall be * included in all copies or substantial portions of the Software. * * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR * OTHER DEALINGS IN THE SOFTWARE. **/package com.gskinner.performance {import flash.events.Event;import flash.events.EventDispatcher;import flash.utils.describeType;/** * Dispatched when all of the tests in the suite have completed. * @eventType flash.events.Event **/[Event(name="complete", type="flash.events.Event")]/** * Test suites allow you to organize and aggregate related tests. It makes tests * more portable, generates better organized output, and gives access to some aggregate * information, like total time. You can run or queue an entire suite as one item. If * it is queued, each iteration of each test will be run independently with a delay between them. * If it is run (ex. PerformanceTest.run(myTestSuite) ), then all of the tests will * be run synchronously. * <br/><br/> * There are three ways to build test suites: * <br/><br/> * 1. Inheritance. Extend TestSuite, add the methods to test in the subclass, and define all of the * necessary properties in the constructor. This creates a very portable collection of tests. * <br/><br/> * 2. Composition. Create a new TestSuite instance, and set its properties, including specifying tests to run * using methods from other classes. This provides a formal, but slightly more adhoc method of creating suites. * <br/><br/> * 3. Using <code>fromObject</code>. This allows you to generate TestSuites from any object with public methods. * See <code>fromObject</code> for details. **/public class TestSuite extends EventDispatcher {	// static interface:	/**	 * This provides you with a simple way to quickly generate a TestSuite instance from any object with	 * public methods.	 * <br/><br/>	 * If you pass in a generic <code>Object</code>, it will scan all of its dynamic properties for methods,	 * and add any methods that are not prefixed with an underscore to the suite as new Test instances.	 * <br/><br/>	 * If you pass in a typed object, it will add all of its uninherited public methods that are not prefixed with an	 * underscore.	 * <br/><br/>	 * In both cases, it will scan for the existence of label, description, iterations, loops, and id properties on the	 * object, and apply them to the test suite if they are not specified as parameters. It will also look for an init function	 * to set as initFunction, and a tare function to use for the tareTest.	 **/	public static function fromObject(o:Object, name:String = null, iterations:uint = 1, testLoops:uint = 1, description:String = null):TestSuite {		var tests:Array = [];		var testSuite:TestSuite = new TestSuite(tests);		var desc:XML = describeType(o);		var type:String = desc.@name;		testSuite.name = name ? name : "name" in o ? o.label : type.split("::").join(".");		testSuite.description = description ? description : "description" in o ? o.description : null;		testSuite.tareTest = ("tare" in o && o.tare is Function) ? new MethodTest(o.tare, null, "tare") : null;		testSuite.initFunction = ("init" in o && o.init is Function) ? o.init : null;		testSuite.iterations = iterations;		if (type == "Object") {			for (var n:String in o) {				if (!(n is Function) || n.charAt(0) == "_" || n == "tare" || n == "init") {					continue;				}				tests.push(new MethodTest(o[n], null, n));			}		} else {			var methods:XMLList = desc..method.(@declaredBy == type);			var l:uint = methods.length();			for (var i:int = 0; i < l; i++) {				var method:XML = methods[i];				var name:String = method.@name;				if (name.charAt(0) == "_" || name == "tare" || name == "init") {					continue;				}				tests.push(new MethodTest(o[name], null, name, 0, testLoops));			}		}		// sort the method list, so there's some kind of order:		tests.sortOn("name", Array.CASEINSENSITIVE);		testSuite.tests = tests;		return testSuite;	}	// public properties:	/** An array of the AbstractTest instances in this suite. **/	public var tests:Array;	/**	 * Optional name for this test suite. This is used for display purposes,	 * and could also be used to uniquely identify the test suite for analytics systems.	 **/	public var name:String;	/** Optional description for this test. **/	public var description:String;	/**	 * This specifies a test to use for taring. This test should establish a baseline time that	 * can be used to isolate the significant time in other tests. For example, if you created a	 * suite of tests that all ran a loop 1000 times to test code in the loop, you could write a	 * tare test that runs an empty loop 1000 times, to isolate the time spent on the loop from the	 * time executing the code within the loop.	 * <br/><br/>	 * Tare tests are treated differently than other tests. They are run until two subsequent runs return	 * substantially similar results, and the average time for those two is recorded as the tareTime for the	 * suite. This time will differ from the <code>time</code> value on the test itself.	 * <br/><br/>	 * The iteration property on the tareTest can be set to specify a maximum number of times to attempt to	 * run the tareTest or left at 0 to use the default of 10. After running, the iteration property indicates	 * how many times the tareTest was run to get consistent results. If consistent results are not obtained,	 * then tareTime is set to -1.	 * <br/><br/>	 * Reporting systems may choose to subtract the tareTime from each test's time to isolate only the	 * significant portion of the result.	 **/	public var tareTest:AbstractTest;	/**	 * This allows you to specify a function to execute prior to executing any of the tests (including the tareTest). This is useful	 * for setting up data structures or conditions that your tests require, but which you do not want included	 * in the timed results.	 **/	public var initFunction:Function;	/** See tareTest for a full explanation of tareTime. **/	public var tareTime:int = 0;	/** Indicates the time it took to run the initFunction. **/	public var initTime:int = 0;	/**	 * Specifies the default number of iterations to use for any test in this suite with iterations=0.	 * If this value is also 0, then the PerformanceTest default of 1 is used.	 **/	public var iterations:uint = 0;	// constructor:	/**	 * Creates a new instance of TestSuite. See properties for parameter information.	 **/	public function TestSuite(tests:Array = null, name:String = null, tareTest:AbstractTest = null, initFunction:Function = null, iterations:uint = 0, description:String = null) {		this.tests = tests ? tests : this.tests ? this.tests : [];		if (name) {			this.name = name;		}		if (description) {			this.description = description;		}		if (tareTest != null) {			this.tareTest = tareTest;		}		if (initFunction != null) {			this.initFunction = initFunction;		}		if (iterations > 0) {			this.iterations = iterations;		}	}	// public methods:	/**	 * Returns the aggregate time of all tests, or -1 if any test has not run successfully.	 **/	public function get time():int {		var time:int = 0;		var l:uint = tests.length;		for (var i:uint = 0; i < l; i++) {			var t:int = tests[i].time;			if (t == -1) {				return -1;			}			time += t;		}		return time;	}	/**	 * PerformanceTest calls <code>complete()</code> when all of the tests in the suite have been run. This causes	 * the suite to dispatch the COMPLETE event. You would not generally call this method directly.	 **/	public function complete():void {		dispatchEvent(new Event(Event.COMPLETE));	}	/**	 * Returns XML containing all of the information about this test suite and the tests it contains.	 * This is very useful for building analysis tools, and for saving out results to compare them in the future.	 * <br/><br/>	 * I might document the format some day, but for now it's simple enough to just trace the output of this function	 * to see it.	 **/	public function toXML():XML {		var xml:XML = <TestSuite name="" time={time} tareTime={tareTime} initTime={initTime}/>		if (name) {			xml.@name = name;		}		if (description) {			xml.@description = description;		}		var error:Boolean = false;		var l:uint = tests.length;		for (var i:uint = 0; i < l; i++) {			var test:AbstractTest = tests[i];			error ||= test.error != null;			xml.* += test.toXML();		}		xml.@error = error ? "true" : "false";		return xml;	}	/**	 * Returns a string representation of this TestSuite. Very handy for tracing:<br/>	 * <code>trace(myTestSuite);</code>	 **/	override public function toString():String {		var str:String = "[TestSuite" + (name ? " name='" + name + "'" : "") + " tareTime=" + tareTime + " time=" + time + "]";		var l:uint = tests.length;		for (var i:uint = 0; i < l; i++) {			var test:AbstractTest = tests[i];			str += "\n\t" + test.toString();		}		return str;	}}}