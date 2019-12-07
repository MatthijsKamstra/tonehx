package data;

import haxe.io.Path;
import AST.JsdocObject;

using StringTools;

class ClassObj extends BaseObj {
	public var constructor:String; // create constructor

	public var exampleString:String; // how does a example look like
	public var extendsString:String; // easy way to write a extend
	public var importString:String; // path for import (without `import `)
	public var extendsArray:Array<String>; // array extends values

	public function new(obj:JsdocObject) {
		super(jsdoc);

		var example = obj.examples; // is array
		var extendz = obj.augments; // is array // Tone.Monophonic

		this.exampleString = (example != null) ? "@example (JavaScript code):\n * \t\t" + example[0].replace("\n", "\n * \t\t") : "";
		this.extendsString = (extendz != null) ? "extends " + extendz[0].replace("Tone.", "") : "";
		this.extendsArray = (extendz != null) ? [extendz[0].replace("Tone.", "")] : [];
		// this.importString = '${export}.${this.folder}.${this.name};';

		// constructor
		var constructorComment = '';
		var params = '';
		if (obj.params != null) {
			for (i in 0...obj.params.length) {
				var _params:AST.Params = obj.params[i];
				var _description = (_params.description != null) ? _params.description.replace("\n", " ").replace("/t", " ").replace("  ", "") : "";
				constructorComment += '\n\t * @param ${_params.name}\t${_description}';

				var __type = convertTypeTwo(_params.type.names);
				params += (_params.optional == true) ? "?" : "";
				params += '${_params.name}:';
				params += '${__type}';
				if (i < obj.params.length - 1)
					params += ', ';
			}
		}
		this.constructor = (obj.params != null) ? '/**\n\t * ${constructorComment}\n\t */\n\tpublic function new(${params}):Void;' : '';
	}

	public function toString() {
		return '--';
	}
}
