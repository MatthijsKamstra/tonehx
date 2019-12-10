package data;

import haxe.io.Path;
import AST.JsdocObject;

using StringTools;

/**
	{
	comment: '',
	meta: {
		range: [ 658, 1465 ],
		filename: 'Synth.js',
		lineno: 19,
		columnno: 0,
		path: '/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/instrument',
		code: {
			id: 'astnode100050523',
			name: 'Tone.Synth',
			type: 'FunctionExpression',
			paramnames: [Array]
		},
		vars: {
			options: 'Tone.Synth~options',
			'this.oscillator': 'Tone.Synth#oscillator',
			'this.frequency': 'Tone.Synth#frequency',
			'this.detune': 'Tone.Synth#detune',
			'this.envelope': 'Tone.Synth#envelope'
		}
	},
	kind: 'class',
	classdesc: 'Tone.Synth is composed simply of a Tone.OmniOscillator\n' +
	'         routed through a Tone.AmplitudeEnvelope.\n' +
	'         <img src="https://docs.google.com/drawings/d/1-1_0YW2Z1J2EPI36P8fNCMcZG7N1w1GZluPs4og4evo/pub?w=1163&h=231">',
	augments: [ 'Tone.Monophonic' ],
	params: [
	{
		type: [Object],
		optional: true,
		description: 'the options available for the synth\n' +
		'                         see defaults below',
		name: 'options'
	}
	],
	examples: [
		'var synth = new Tone.Synth().toMaster();\n' +
		'synth.triggerAttackRelease("C4", "8n");'
	],
	name: 'Synth',
	longname: 'Tone.Synth',
	memberof: 'Tone',
	scope: 'static',
	___id: 'T000002R003795',
	___s: true
	}
 */
class ClassObj extends BaseObj {
	public var constructor:String; // create constructor

	public var exampleString:String; // how does a example look like
	public var extendsString:String; // easy way to write a extend
	public var extendsArray:Array<String>; // array extends values

	public function new(doc:JsdocObject) {
		super(doc);

		var example = doc.examples; // is array
		var extendz = doc.augments; // is array // Tone.Monophonic

		this.exampleString = (example != null) ? "@example (JavaScript code):\n * \t\t" + example[0].replace("\n", "\n * \t\t") : "";
		this.extendsString = (extendz != null) ? "extends " + extendz[0].replace("Tone.", "") : "";
		this.extendsArray = (extendz != null) ? [extendz[0].replace("Tone.", "")] : [];

		if (extendz != null) {
			if (extendz.length > 1) {
				trace(extendz.length);
				trace('this might be a problem: ${this.className}');
			}
		}

		// constructor
		var constructorComment = '// constructor\n\t * ';
		var params = '';
		if (doc.params != null) {
			for (i in 0...doc.params.length) {
				var _params:AST.Params = doc.params[i];
				var _description = (_params.description != null) ? _params.description.replace("\n", " ").replace("/t", " ").replace("  ", "") : "";
				constructorComment += '\n\t * @param ${_params.name}\t${_description}';

				var __type = convertType2String(_params.type.names);
				params += (_params.optional == true) ? "?" : "";
				params += '${_params.name}:';
				params += '${__type}';
				if (i < doc.params.length - 1)
					params += ', ';
			}
		}
		this.constructor = (doc.params != null) ? '\t/**\n\t * ${constructorComment}\n\t */\n\tpublic function new(${params}):Void;\n' : '';
	}

	public function toString() {
		return '--';
	}
}
