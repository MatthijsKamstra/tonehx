package;

/**
 * Generated with HxJsonDef (version 0.0.8) on Tue Dec 03 2019 11:50:15 GMT+0100 (Central European Standard Time)
 * from : http://matthijskamstra.github.io/hxjsondef/
 *
 * AST = Abstract Syntax Tree
 *
 * Note:
 * If you provide a .json there should be no null values
 * comments in this document show you the values that need to be changed!
 *
 * Some (backend)-developers choose to hide empty/null values, you can add them:
 * 		@:optional var _id : Int;
 *
 * Name(s) that you possibly need to change:
 * 		JsdocObject
 * 		Meta
 * 		Code
 * 		Vars
 * 		Params
 * 		Type
 */
typedef JSDocs = {
	var docs:Array<JsdocObject>;
}

typedef JsdocObject = {
	var comment:String;
	var meta:Meta;
	var kind:JSDocKind;
	var classdesc:String;
	var augments:Array<String>;
	var params:Array<Params>;
	var returns:Array<Returns>;
	var examples:Array<String>;
	var name:String;
	var longname:String;
	var memberof:String;
	var scope:JSDocScope;
	@:optional var description:String;
	@:optional var undocumented:Bool;
	@:optional var access:String;
	@:optional var readonly:Bool;
	@:optional var inherited:Bool;
	@:optional var virtual:Bool;
	@:optional var type:Typez;
	@:optional var overrides:String;
};

typedef Meta = {
	var range:Array<Int>;
	var filename:String;
	var lineno:Int;
	var columnno:Int;
	var path:String;
	var code:Code;
	var vars:Vars;
};

typedef Code = {
	var id:String;
	var name:String;
	var type:String;
	var paramnames:Array<Dynamic>; // paramnames:null // [mck] provide json without `null` values
};

typedef Vars = {
	var input:String;
	var output:String;
};

typedef Params = {
	var type:Typez;
	var optional:Bool;
	var description:String;
	var name:String;
};

typedef Returns = {
	var type:Typez;
	var optional:Bool;
	var description:String;
	var name:String;
};

typedef Typez = {
	var names:Array<String>;
};

typedef JSDoc = {
	var comment:String;
	var meta:JSDocMeta;
	var kind:JSDocKind;
	var name:String;
	@:optional var type:JSDocTypeNames;
	@:optional var access:JSDocAccess;
	@:optional var params:Array<JSDocParam>;
	@:optional var returns:Array<JSDocReturn>;
	var memberof:String;
	var longname:String;
	var scope:JSDocScope;
}

typedef JSDocMeta = {
	var filename:String;
}

typedef JSDocParam = {
	var type:JSDocTypeNames;
	var description:String;
	var name:String;
	@:optional var optional:Bool;
	@:optional var defaultvalue:Any;
}

typedef JSDocTypeNames = {
	var names:Array<JSDocType>;
}

typedef JSDocReturn = {
	var type:JSDocTypeNames;
	var description:String;
}

@:enum abstract JSDocKind(String) {
	var Class = 'class';
	var Function = 'function';
	var Member = 'member';
	var Event = 'event';
	var TypeDef = 'typedef';
	var NameSpace = 'namespace';
	// tonejs specific
	var Constant = 'constant';
	var Package = 'package';
}

@:enum abstract JSDocAccess(String) {
	var Public = 'public';
	var Private = 'private';
	var Protected = 'protected';
}

@:enum abstract JSDocScope(String) {
	var Static = 'static';
	var Global = 'global';
	var Instance = 'instance';
}

@:enum abstract JSDocType(String) from String {
	var Number = 'number';
	var Float = 'float';
	var Integer = 'integer';
	var String = 'string';
	var Boolean = 'boolean';
	var Array = 'array';
	var Function = 'function';
	var Null = 'null';
	var Any = 'any';
	var Object = 'object';
	var ObjectDef = 'Object';
}
