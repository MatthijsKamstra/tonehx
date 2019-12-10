package data;

import AST.JsdocObject;

using StringTools;

/**
	{
	comment: '',
	meta: {
	  range: [Array],
	  filename: 'Synth.js',
	  lineno: 36,
	  columnno: 1,
	  path: '/Users/matthijs/Documents/GIT/tonehx/bin/tonejs/Tone/instrument',
	  code: [Object]
	},
	description: 'The frequency control.',
	type: { names: [Array] },
	tags: [ [Object] ],
	name: 'frequency',
	longname: 'Tone.Synth#frequency',
	kind: 'member',
	memberof: 'Tone.Synth',
	scope: 'instance',
	___id: 'T000002R003798',
	___s: true
	 }
 */
class MemberObj extends BaseObj {
	public var description:String;

	// public var type:String;

	public function new(doc:JsdocObject) {
		super(doc);
		this.description = (doc.description != null) ? doc.description.replace('\n', ' ').replace('  ', ' ') : '';
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
			// [mck] something weird but not sure what to doe with inherited members
			str += '\t// ${_access} var ${this.name}:${this.typeString};\n';
		} else {
			str += '\n\t// ${this.description}\n';
			str += '\t${_access} var ${this.name}:${this.typeString};\n';
		}
		return str;
	}
}
