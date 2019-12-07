package data;

import haxe.io.Path;
import AST.JsdocObject;

using StringTools;

class TypedefObj extends BaseObj {
	public var description:String; // class name

	public function new(obj:JsdocObject) {
		super(obj);
		this.description = (obj.description != null) ? obj.description.replace("* ", "").replace("\n", "\n * ") : "";
	}
}
