package data;

import AST.JSDocKind;
import haxe.display.JsonModuleTypes.JsonTypeKind;
import haxe.ds.StringMap;
import haxe.io.StringInput;
import AST.JsdocObject;

using StringTools;

class BaseObj {
	public var jsdoc:JsdocObject; // AST generated by JsDoc
	public var className:String; // in which class @example: `AmplitudeEnvelope`
	public var name:String; // name of object

	public var classdesc:String; // documentation (class  documentation) \\  "classdesc": "xxx"

	public var path:String; // path to export folder and "package"  @example: `tone/component`
	public var pathArray:Array<String>; // path to export folder and "package"  @example: `tone.component`

	/**
	 * dot-path for import (without `import`)
	 *
	 * @example : `tone.component.AmplitudeEnvelope`
	 */
	public var pathImport:String;

	/**
	 * dot-path for export (with extension `.hx`)
	 *
	 * @example : `tone/component/AmplitudeEnvelope.hx`
	 */
	public var pathExport:String;

	public function new(doc:JsdocObject) {
		// only one that will not work with Base.

		if (doc.kind == JSDocKind.Package)
			return;

		this.jsdoc = doc;

		this.name = doc.name; //     "name": "AmplitudeEnvelope",
		this.classdesc = convertDoc(doc.classdesc); // only with class
		// this.className = (doc.meta != null) ? doc.meta.filename.replace(".js", "") : doc.name; // "filename":"AmplitudeEnvelope.js",
		this.className = doc.meta.filename.replace(".js", ""); // "filename":"AmplitudeEnvelope.js",
		// `tonejs` is the folder with spit the files into HARDCODED
		var _path = doc.meta.path.split("tonejs/")[1].toLowerCase(); // "path": "/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/component",
		pathArray = _path.split('/'); // [tone,component]
		this.path = pathArray.join('/');
		this.pathImport = '${pathArray.join('.')}.${this.className}'; // tone.component.AmplitudeEnvelope (without import)
		this.pathExport = '${pathArray.join('/')}/${this.className}.hx'; // path for export @example : `tone/component/AmplitudeEnvelope.hx`
	}

	public function convertReturn(returns:Array<AST.Returns>):String {
		var arr = [];
		if (returns != null) {
			for (i in 0...returns.length) {
				var _return = returns[i];
				for (j in 0..._return.type.names.length) {
					var _name = _return.type.names[j];
					var __p = convertType(_name);
					arr.push(__p);
				}
			}
		}
		return arr[0];
	}

	public function convertParams2Array(params:Array<AST.Params>):Array<String> {
		var arr = [];
		if (params != null) {
			for (i in 0...params.length) {
				var param = params[i];
				for (j in 0...param.type.names.length) {
					var _name = param.type.names[j];
					var __p = convertType(_name);
					arr.push(__p);
				}
			}
		}
		return arr;
	}

	public function convertType2Array(names:Array<String>):Array<String> {
		var arr = [];
		for (i in 0...names.length) {
			var _names = names[i];
			var __p = convertType(_names);
			arr.push(__p);
		}
		return arr;
	}

	/**
	 * convert types to param
	 * @param names
	 * @return String
	 */
	public function convertTypeTwo(names:Array<String>):String {
		var p = "##";
		var arr = convertType2Array(names);

		if (names.length == 1) {
			p = arr[0];
		}

		if (names.length == 2) {
			p = 'haxe.extern.EitherType<${arr[0]}, ${arr[1]}>';
		}
		if (names.length == 3) {
			p = 'haxe.extern.EitherType<${arr[0]}, haxe.extern.EitherType<${arr[1]},${arr[2]}>>';
		}
		if (names.length == 4) {
			p = 'haxe.extern.EitherType<${arr[0]}, haxe.extern.EitherType<${arr[1]},haxe.extern.EitherType<${arr[2]},${arr[3]}>>>';
		}
		return p;
	}

	// make this doc better?
	public function convertDoc(doc:String):String {
		if (doc == "" || doc == null)
			return '';
		return doc.replace("\t", "").replace("***", "").replace("  ", "").replace("\n", "\n * ");
	}

	/**
	 * convert JavaScript types to Haxe types
	 * @param type
	 * @return String
	 */
	public function convertType(type:String):String {
		var _type = type.replace("Tone.", "");
		if (_type == "number" || _type == "Number") {
			_type = "Float";
		}
		if (_type == "function" || _type == "Function") {
			_type = "haxe.Constraints.Function";
			// _type = "js.Lib.Function";
		}
		if (_type == "boolean" || _type == "Boolean") {
			_type = "Bool";
		}
		if (_type == "" || _type == "*") {
			_type = "Dynamic";
		}
		if (_type == "string" || _type == "String") {
			_type = "String";
		}
		if (_type == "Array.<Number>") {
			_type = "Array<Float>";
		}
		if (_type == "Array") {
			_type = "Array<Dynamic>";
		}
		if (_type.indexOf("Array.") != -1) {
			_type = _type.replace("Array.", "Array");
		}
		if (_type == "Object" || _type == "object") {
			_type = "Dynamic";
		}
		if (_type == "undefined") {
			_type = "Dynamic";
		}
		if (_type == "Promise") {
			_type = "Promise<Dynamic>";
		}
		return _type;
	}
}