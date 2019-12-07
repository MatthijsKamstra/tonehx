package data;

import haxe.io.Path;
import AST.JsdocObject;

using StringTools;

class FunctionObj extends BaseObj {
	public var description:String;
	public var params:Array<AST.Params>;
	public var returns:Array<AST.Returns>;

	public var functionParams:String;
	public var functionComment:String;
	public var functionReturn:String;
	public var typesArray:Array<String>;

	// public var type:String;

	public function new(obj:JsdocObject) {
		super(jsdoc);
		// this.type = this.className;
		this.description = (obj.description != null) ? obj.description.replace("\n", "\n\t * ") : "";
		this.params = (obj.params != null) ? obj.params : [];
		this.returns = (obj.returns != null) ? obj.returns : [];

		this.typesArray = convertParams2Array(obj.params); // //

		this.functionReturn = convertReturn(obj.returns);

		this.functionParams = '';

		this.functionComment = '\n\n\t/**';
		this.functionComment += '\n\t * ${this.description}';
		this.functionComment += '\n\t *';
		// check if there are params for this function
		if (obj.params != null) {
			// get all params for this function
			for (i in 0...obj.params.length) {
				var _params:AST.Params = obj.params[i];
				var _description = (_params.description != null) ? _params.description.replace("\n", " ").replace("/t", " ").replace("  ", "") : "";
				this.functionComment += '\n\t * @param ${_params.name}\t${_description}';

				var __type = convertTypeTwo(_params.type.names);
				functionParams += (_params.optional == true) ? "?" : "";
				functionParams += '${_params.name}:';
				functionParams += '${__type}';
				if (i < obj.params.length - 1)
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
}
