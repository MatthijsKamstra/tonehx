package data;

import AST.JsdocObject;

class MemberObj extends BaseObj {
	public var description:String;
	public var type:String;

	public function new(obj:JsdocObject) {
		super(jsdoc);
	}
}
