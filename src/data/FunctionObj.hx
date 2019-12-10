package data;

import haxe.io.Path;
import AST.JsdocObject;

using StringTools;

/**
	{
	comment: '',
	meta: {
	  range: [Array],
	  filename: 'Synth.js',
	  lineno: 99,
	  columnno: 0,
	  path: '/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/instrument',
	  code: [Object],
	  vars: [Object]
	},
	description: 'start the release portion of the envelope',
	params: [ [Object] ],
	returns: [ [Object] ],
	access: 'private',
	name: '_triggerEnvelopeRelease',
	longname: 'Tone.Synth#_triggerEnvelopeRelease',
	kind: 'function',
	memberof: 'Tone.Synth',
	scope: 'instance',
	overrides: 'Tone.Monophonic#_triggerEnvelopeRelease',
	___id: 'T000002R003810',
	___s: true
	}
 */
class FunctionObj extends BaseObj {
	public var description:String;
	public var params:Array<AST.Params>;
	public var returns:Array<AST.Returns>;

	public var functionParams:String;
	public var functionComment:String;
	public var functionReturn:String;
	public var typesArray:Array<String>;

	// public var type:String;

	public function new(doc:JsdocObject) {
		super(doc);
		// this.type = this.className;
		this.description = (doc.description != null) ? doc.description.replace("\n", "\n\t * ") : "";
		this.params = (doc.params != null) ? doc.params : [];
		this.returns = (doc.returns != null) ? doc.returns : [];

		this.typesArray = convertParams2Array(doc.params);
		this.functionReturn = convertReturn(doc.returns);

		this.functionParams = '';

		this.functionComment = '\n\n\t/**';
		this.functionComment += '\n\t * ${this.description}';
		this.functionComment += '\n\t *';
		// check if there are params for this function
		if (doc.params != null) {
			// get all params for this function
			for (i in 0...doc.params.length) {
				var _params:AST.Params = doc.params[i];
				var _description = (_params.description != null) ? _params.description.replace("\n ", " ")
					.replace("\n", " ")
					.replace("\t", " ")
					.replace("  ", "") : "";
				this.functionComment += '\n\t * @param ${_params.name}\t${_description}';

				var __type = convertType2String(_params.type.names);
				functionParams += (_params.optional == true) ? "?" : "";
				functionParams += '${_params.name}:';
				functionParams += '${__type}';
				if (i < doc.params.length - 1)
					functionParams += ', ';
			}
		}
		this.functionComment += '\n\t * @return\t${this.functionReturn}';
		this.functionComment += '\n\t */';
		/**
		 *
		 *
		 * @param note	The note to play
		 * @param time	When to play the note
		 * @param velocity	The velocity to play the sample back.
		 * @return	Sampler
		 */
	}

	public function toString():String {
		var str = '';
		var _access = 'public';
		if (this.jsdoc.access == 'private') {
			_access = 'private';
		} else {
			if (this.jsdoc.access == null) {} else {
				trace('not sure what to do with this: ${this.jsdoc.access}');
			}
		}

		if (_access == 'private' || this.jsdoc.inherited == true) {
			str += '\n\t// ${_access} function ${this.name} (${this.functionParams}):${this.functionReturn};';
		} else {
			str += '${this.functionComment}';
			str += '\n\t${_access} function ${this.name} (${this.functionParams}):${this.functionReturn};';
		}

		return str;
	}
}
