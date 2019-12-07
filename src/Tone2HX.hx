package;

import haxe.io.Path;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import data.*;
import AST;

using StringTools;
using Tone2HX;

class Tone2HX {
	var FILE_NAME:String = 'doc.json';
	var EXPORT:String = 'tone'; // folder to generate files in (in this case `docs` folder from github )

	//
	var classCounter = 0;
	var memberCounter = 0;
	var functionCounter = 0;
	var constantCounter = 0;
	var typedefCounter = 0;
	var packageCounter = 0;

	// var map:Map<String, String> = new Map();
	var classMap:Map<String, ClassObj> = new Map();
	var memberMap:Map<String, Array<MemberObj>> = new Map();
	var funcMap:Map<String, Array<FunctionObj>> = new Map();
	// var constantMap:Map<String, Array<ConstantObj>> = new Map();
	var typedefMap:Map<String, Array<TypedefObj>> = new Map();
	var packageMap:Map<String, String> = new Map();
	var classes:Map<String, HXClass> = new Map<String, HXClass>();

	public function new() {
		trace("Convert Tone.js JsDoc to Haxe externs");
		loadJSON(FILE_NAME);
	}

	function loadJSON(jsonFile:String):Void {
		if (FileSystem.exists(jsonFile)) {
			var json:String = null;
			try {
				json = Json.parse(File.getContent(jsonFile));
			} catch (e:String) {
				trace(e);
			}
			if (json != null)
				processJSON(cast json);
		} else {
			trace('File $jsonFile not exists!');
		}
	}

	function processJSON(json:JSDocs):Void {
		trace(json.docs.length);
		var kindArr:Array<JSDocKind> = [];
		for (doc in json.docs) {
			var _kind = doc.kind;
			if (_kind == JSDocKind.Package) {
				initPackage(doc);
				packageCounter++;
				continue;
			}

			var className = doc.meta.filename.replace(".js", ""); // "filename":"AmplitudeEnvelope.js",
			// `tonejs` is the folder with spit the files into HARDCODED
			var _path = doc.meta.path.split("tonejs/")[1].toLowerCase(); // "path": "/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/component",
			var pathArray = _path.split('/'); // [tone,component]
			var pathImport = '${pathArray.join('.')}.${className}'; // tone.component.AmplitudeEnvelope (without import)
			var pathExport = '${pathArray.join('/')}/${className}.hx'; // path for export @example : `tone/component/AmplitudeEnvelope.hx`

			var longPath = pathImport;
			var hxClass:HXClass = classes.get(longPath);
			if (hxClass == null)
				classes.set(longPath, hxClass = {});
			var kinds:Array<JsdocObject> = Reflect.field(hxClass, '_${doc.kind}');
			if (kinds == null)
				Reflect.setField(hxClass, '_${doc.kind}', kinds = []);
			kinds.push(doc);

			if (_kind == JSDocKind.Class) {
				classCounter++;
			}
			if (_kind == JSDocKind.Member) {
				memberCounter++;
			}
			if (_kind == JSDocKind.Function) {
				functionCounter++;
			}
			if (_kind == JSDocKind.Constant) {
				constantCounter++;
			}
			if (_kind == JSDocKind.TypeDef) {
				typedefCounter++;
			}

			if (kindArr.indexOf(_kind) == -1) {
				kindArr.push(_kind);
			}
		}
		// total files on file system tone.js // 165
		// trace(json.docs[0]);
		// trace(kindArr);
		trace('classCounter: ' + classCounter + ', memberCounter: ' + memberCounter + ', functionCounter : ' + functionCounter + ', constantCounter: '
			+ constantCounter + ', typedefCounter : ' + typedefCounter + ', packageCounter : ' + packageCounter + ', json.docs.lenght: ' + json.docs.length);
		trace((classCounter + memberCounter + functionCounter + constantCounter + typedefCounter + packageCounter) + ' == ' + json.docs.length);

		createExterns();
	}

	function createExterns() {
		for (classPath in classes.keys()) {
			// trace(classPath);
			var hxClass:HXClass = classes.get(classPath);
			// trace(hxClass);
			// var path:Array<String> = classPath.convertPackages();
			// var className:String = path.last().capital();
			// var content:String = '';
			// content += 'package ${path.head().join('.')};\n';
			// content += '@:native("$classPath")\n';
			// content += 'extern class $className {\n';
			// if (hxClass._member.isNotEmpty())
			// 	content += getMembers(hxClass._member);
			// content += '}';
			// var packagePath:String = path.head().join('/');
			// if (!FileSystem.exists('$out/$packagePath'))
			// 	FileSystem.createDirectory('$out/$packagePath');
			// File.saveContent('$out/$packagePath/$className.hx', content);

			// trace(FileSystem.exists())
		}
		// trace(classes.get('tone.instrument.Synth'));
		trace(Lambda.count(classes));
	};

	/**
	 * not sure this is usefull but lets go with it
	 * @param doc
	 */
	function initPackage(doc:JsdocObject) {
		var filesArray:Array<String> = Reflect.getProperty(doc, "files");
		// trace('package total files: ' + filesArray.length);
		for (i in 0...filesArray.length) {
			var _file = filesArray[i]; //    "/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/component/AmplitudeEnvelope.js",
			var _path = _file.split("tonejs/")[1].toLowerCase(); //    "tone/component/amplitudeEnvelope.js",
			var _pathArray = _path.split('/'); //    [tone,component,amplitudeEnvelope.js]
			var _name = capital(_pathArray.pop().replace('.js', '')); // AmplitudeEnvelope
			var arr = [EXPORT];
			for (i in 0..._pathArray.length) {
				arr.push(_pathArray[i]);
			}
			var _export = Path.join(arr);
			// trace(_name, _export + '/' + _name + '.hx');
			packageMap.set(_name, _export);
			if (_name == null)
				continue;
			initHx(_export, _name, '// test: ${_name}');
		}
	}

	/**
	 * simply write the files
	 * @param path 		folder to write the files (current assumption is `EXPORT`)
	 * @param filename	the file name (without extension)
	 * @param content	what to write to the file (in our case markdown)
	 */
	function initHx(path:String, filename:String, content:String) {
		if (!sys.FileSystem.exists(path)) {
			sys.FileSystem.createDirectory(path);
		}
		var _file = path + '/${filename}.hx';

		sys.io.File.saveContent(_file, content);
		// console.log('written file: ${_file}');
	}

	public static inline function capital(string:String):String
		return string.substring(0, 1).toUpperCase() + string.substring(1);

	static public function main() {
		var app = new Tone2HX();
	}
}

typedef HXClass = {
	@:optional var _class:Array<JsdocObject>;
	@:optional var _member:Array<JsdocObject>;
	@:optional var _function:Array<JsdocObject>;
	@:optional var _event:Array<JsdocObject>;
	@:optional var _typedef:Array<JsdocObject>;
	@:optional var _namespace:Array<JsdocObject>;
	//
	@:optional var _constant:Array<JsdocObject>;
	@:optional var _package:Array<JsdocObject>;
}
