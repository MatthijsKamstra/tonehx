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
	var VERSION:String = '13.8.24'; // tone.js version

	// var EXPORT:String = 'tone'; // folder to generate files in (in this case `docs` folder from github )
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
				var arr:Array<TypedefObj> = [];
				if (typedefMap.exists(longPath)) {
					arr = typedefMap.get(longPath);
				}
				arr.push(new TypedefObj(doc));
				typedefMap.set(longPath, arr);
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
			// trace(classPath, hxClass._class);
			if (hxClass._class == null) {
				trace('has no class??? : ' + classPath);
				continue;
			}
			if (hxClass._class.length > 1) {
				trace('something weird going on (${classPath}), has more then one class? : _hxClass._class_');
			}
			var _classObj = new ClassObj(hxClass._class[0]);
			var content = '/**\n * Tone.js version ${VERSION}\n * Haxe externs generated on ${Date.now()}\n */\n';
			content += 'package ${_classObj.pathImport};\n\n';
			content += '// I am lazy here... hop this fixes a lot\n';
			content += 'import tone.*;\n';
			content += 'import tone.component.*;\n';
			content += 'import tone.component.Amplitudeenvelope;\n';
			content += 'import tone.control.*;\n';
			content += 'import tone.core.*;\n';
			content += 'import tone.core.Audionode;\n';
			content += 'import tone.effect.*;\n';
			content += 'import tone.event.*;\n';
			content += 'import tone.instrument.*;\n';
			content += 'import tone.shim.*;\n';
			content += 'import tone.signal.*;\n';
			content += 'import tone.source.*;\n';
			content += 'import tone.source.Omnioscillator;\n';
			content += 'import tone.type.*;\n';
			content += 'import tone.type.Type;\n';
			content += 'import tone.type.Timebase;\n';
			content += 'import js.html.audio.AudioParam;\n';
			content += 'import js.html.audio.AudioContext;\n';
			content += 'import js.lib.Promise;\n';
			content += '// import js.html.audio.AudioNode;\n\n';

			content += '${_classObj.classdesc}';
			content += '@:native("Tone.${_classObj.className}")\n';
			content += 'extern class ${_classObj.className} ${_classObj.extendsString} {\n';
			content += '${_classObj.constructor}';
			if (hxClass._member != null) {
				content += '\n\t// -------------------- MEMBERS --------------------\n';
				for (i in 0...hxClass._member.length) {
					var _memberObj = new MemberObj(hxClass._member[i]);
					content += _memberObj.toString();
				}
			}
			if (hxClass._function != null) {
				content += '\n\t// -------------------- FUNCTIONS --------------------\n';
				for (i in 0...hxClass._function.length) {
					var _functionObj = new FunctionObj(hxClass._function[i]);
					content += _functionObj.toString();
				}
			}
			content += '\n}';
			initHx(_classObj.path, _classObj.className, content);
		}

		// tone.instrument.Synth
		var hxClass:HXClass = classes.get('tone.instrument.Instrument');
		var _classObj = new ClassObj(hxClass._class[0]);

		// trace(hxClass._class[0]);
		// trace(hxClass._member[0]);
		// trace(hxClass._class);
		// trace(hxClass._member);
		// trace(hxClass._function);
		// trace(hxClass._event); // undefined
		// trace(hxClass._typedef); // undefined
		// trace(hxClass._namespace); // undefined
		// trace(hxClass._constant); // 1
		// trace(hxClass._package); // undefined

		// for (_typedef in typedefMap.keys()) {
		// 	// trace('${_typedef}');
		// 	var arr = typedefMap.get('$_typedef');
		// }

		// trace(Lambda.count(typedefMap));
		createTypedef(typedefMap);
	};

	function createTypedef(typedefMap:Map<String, Array<TypedefObj>>) {
		for (className in typedefMap.keys()) {
			var _typedefArr:Array<TypedefObj> = typedefMap[className];
			var path = '';
			var name = '';
			var template = '';
			for (i in 0..._typedefArr.length) {
				var _r:TypedefObj = _typedefArr[i];

				if (_r.name == "Decibel")
					continue;
				if (_r.name == "Time")
					continue;
				if (_r.name == "Frequency")
					continue;

				path = _r.path;
				name = _r.className;
				template += '\n
/**
 * ${_r.description}
 */
typedef ${_r.name} = {

};
';

			}
			template += 'typedef State = {}';
			template += 'typedef BufferSourceNode = {}';
			template = 'package tone.type; \n\n' + template;
			initHx(path, name, template);
		}
	}

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
			var arr = [];
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
