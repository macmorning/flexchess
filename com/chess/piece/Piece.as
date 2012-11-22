package com.chess.piece
{
	import com.chess.square.BoardSquare;
	
	import flash.events.*;
	
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Image;
	
	
	public class Piece extends Image
	{
		public var pieceName:String;  // pone, bishop, queen ...
		public var pieceCode:String;  // pone, bishop, queen ...
 		public var initialPosition:String; // b2, ...
 		public var position:String = ""; // b2, ...
 		public var inGame:Boolean = true;
		public var color:String;
		public var blocable:Boolean = true;
		public var check:Boolean = false;
		public var checker:Piece = null;
		public var castleable:Boolean = true;

		public function Piece(id:String,name:String,color:String,position:String)
		{
			super();
			this.id = id ;
			this.name = id;
			this.pieceName = name;
			this.initialPosition = position;
			this.position = position;
			this.color = color;
			this.styleName = "piece";
			this.source="images/" + color + pieceName + ".gif";
			this.blocable = (this.pieceName == "knight" ? false : true);
			switch (this.pieceName) {
				case "pawn":
					this.pieceCode = "";
					break;
				case "knight":
					this.pieceCode = "N";
					break;
				default:
					this.pieceCode = this.pieceName.charAt(0).toUpperCase();
					break;
			}
			 
		}
				
		private function numeric(id:String):int
		{
			var numericColumns:Array = [];
			numericColumns["a"]=10;
			numericColumns["b"]=20;
			numericColumns["c"]=30;
			numericColumns["d"]=40;
			numericColumns["e"]=50;
			numericColumns["f"]=60;
			numericColumns["g"]=70;
			numericColumns["h"]=80;
			return numericColumns[id.charAt(0)] + int(id.charAt(1));
		}
		private function unnumeric(value:int):String
		{
			var numericColumns:Array = [];
			numericColumns[1]="a";
			numericColumns[2]="b";
			numericColumns[3]="c";
			numericColumns[4]="d";
			numericColumns[5]="e";
			numericColumns[6]="f";
			numericColumns[7]="g";
			numericColumns[8]="h";
			return numericColumns[int(String(value).charAt(0))] + String(value).charAt(1);
		}
		
		public function canMove(board:Grid,square:BoardSquare):Boolean
		{
			
			var numericFrom:int = numeric(this.position);
			var numericTo:int = numeric(square.id); 

			var numericMove:int = numericTo - numericFrom; 
			var i:int = 0;
			var squareid:String = "";
			var operator:int = 0;
			
			switch(this.pieceName) {
				case "pawn":
					// mouvement simple ou double ...
					// ... des blancs
					var tmpId:String = "";
					if (this.color == "w" && (numericMove == 1 || numericMove == 2 && this.position.charAt(1) == "2"))
					{
						if (square.numChildren > 0)
						{
							return false;
						}						
						if ( numericMove == 2 )
						{
							tmpId = unnumeric(numericFrom + 1);
							if (BoardSquare(GridRow(board.getChildByName(tmpId.charAt(1))).getChildByName(tmpId)).numChildren > 0)
							{
								return false;
							}
						}
						return true;
					}
					// ... des noirs
					else if (this.color == "b" && (numericMove == -1 || numericMove == -2 && this.position.charAt(1) == "7"))
					{
						if (square.numChildren > 0)
						{
							return false;
						}
						if ( numericMove == -2 )
						{
							tmpId = unnumeric(numericFrom - 1);
							if (BoardSquare(GridRow(board.getChildByName(tmpId.charAt(1))).getChildByName(tmpId)).numChildren > 0)
							{
								return false;
							}
						}
						return true;
					}
					// prise en diagonale
					else if ((this.color == "w" && (numericMove == 11 || numericMove == -9)) || (this.color == "b" && (numericMove == -11 || numericMove == 9)))
					{
						if (square.numChildren == 0)
						{
							return false;
						}
						return true
					}
					break;

				case "knight":
					if (numericMove == 21 
							|| numericMove == -21  
							|| numericMove == 19  
							|| numericMove == -19  
							|| numericMove == 12  
							|| numericMove == -12
							|| numericMove == 8
							|| numericMove == -8)
					{
						return true;
					}  					
					break;

				case "bishop":
					if ((numericMove%11 == 0 && numericMove > 0 && int(this.position.charAt(1)) < int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) < int(String(numericTo).charAt(0)))
						|| (numericMove%11 == 0 && numericMove < 0 && int(this.position.charAt(1)) > int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) > int(String(numericTo).charAt(0)))
						|| (numericMove%9 == 0 && numericMove > 0 && int(this.position.charAt(1)) > int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) < int(String(numericTo).charAt(0)))
						|| (numericMove%9 == 0 && numericMove < 0 && int(this.position.charAt(1)) < int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) > int(String(numericTo).charAt(0)))
						)
					{
						if(numericMove%11 == 0 && numericMove > 0)
						{
							operator = 11;
						}
						else if(numericMove%11 == 0 && numericMove < 0)
						{
							operator = -11;
						}
						else if(numericMove%9 == 0 && numericMove > 0)
						{
							operator = 9;
						}
						else if(numericMove%9 == 0 && numericMove < 0)
						{
							operator = -9;
						}
						for (i = numericFrom+operator ; (i < numericTo && numericMove > 0) || (i > numericTo && numericMove < 0); i += operator)
						{
							squareid = unnumeric(i);
							if (BoardSquare(GridRow(board.getChildByName(squareid.charAt(1))).getChildByName(squareid)).numChildren > 0)
							{
								return false;
							}
						}  



						return true;
					}
					break;  					

				case "rook":
					if (this.position.charAt(0) == square.id.charAt(0) 
						|| this.position.charAt(1) == square.id.charAt(1) 
						)
					{
						if(this.position.charAt(0) == square.id.charAt(0) && numericMove > 0)
						{
							operator = 1;
						}
						else if(this.position.charAt(0) == square.id.charAt(0) && numericMove < 0)
						{
							operator = -1;
						}
						else if(this.position.charAt(1) == square.id.charAt(1) && numericMove > 0)
						{
							operator = 10;
						}
						else if(this.position.charAt(1) == square.id.charAt(1) && numericMove < 0)
						{
							operator = -10;
						}

						for (i = numericFrom+operator ; (i < numericTo && numericMove > 0) || (i > numericTo && numericMove < 0); i += operator)
						{
							squareid = unnumeric(i);
							if (BoardSquare(GridRow(board.getChildByName(squareid.charAt(1))).getChildByName(squareid)).numChildren > 0)
							{
								return false;
							}
						}  
						return true;
					}
					break;
					
				case "queen":
					if ((numericMove%11 == 0 && numericMove > 0 && int(this.position.charAt(1)) < int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) < int(String(numericTo).charAt(0)))
						|| (numericMove%11 == 0 && numericMove < 0 && int(this.position.charAt(1)) > int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) > int(String(numericTo).charAt(0)))
						|| (numericMove%9 == 0 && numericMove > 0 && int(this.position.charAt(1)) > int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) < int(String(numericTo).charAt(0)))
						|| (numericMove%9 == 0 && numericMove < 0 && int(this.position.charAt(1)) < int(square.id.charAt(1)) && int(String(numericFrom).charAt(0)) > int(String(numericTo).charAt(0)))
						|| this.position.charAt(0) == square.id.charAt(0) 
						|| this.position.charAt(1) == square.id.charAt(1) 
						)
					{
						if(numericMove%11 == 0 && numericMove > 0)
						{
							operator = 11;
						}
						else if(numericMove%11 == 0 && numericMove < 0)
						{
							operator = -11;
						}
						else if(numericMove%9 == 0 && numericMove > 0)
						{
							operator = 9;
						}
						else if(numericMove%9 == 0 && numericMove < 0)
						{
							operator = -9;
						}
						else if(this.position.charAt(0) == square.id.charAt(0) && numericMove > 0)
						{
							operator = 1;
						}
						else if(this.position.charAt(0) == square.id.charAt(0) && numericMove < 0)
						{
							operator = -1;
						}
						else if(this.position.charAt(1) == square.id.charAt(1) && numericMove > 0)
						{
							operator = 10;
						}
						else if(this.position.charAt(1) == square.id.charAt(1) && numericMove < 0)
						{
							operator = -10;
						}

						for (i = numericFrom+operator ; (i < numericTo && numericMove > 0) || (i > numericTo && numericMove < 0); i += operator)
						{
							squareid = unnumeric(i);
							if (BoardSquare(GridRow(board.getChildByName(squareid.charAt(1))).getChildByName(squareid)).numChildren > 0)
							{
								return false;
							}
						}  

						return true;
					}
					break;

				case "king":
					var tmpPiece:Piece;
					if (numericMove == 1
						|| numericMove == -1
						|| numericMove == -11
						|| numericMove == 11
						|| numericMove == -9
						|| numericMove == 9
						|| numericMove == -10
						|| numericMove == 10
						)
					{
						return true;
					}					 
					break;
				 
			}
			return false;
		} 
		
		public function isCheck(board:Grid):Piece
		{
			if (this.pieceName != "king")
			{
				return null;
			}
			for(var i:int = 0 ; i < 8 ; i++)
			{
				for (var j:int = 0 ; j < 8 ; j++)
				{
					if (GridItem(GridRow(board.getChildAt(i)).getChildAt(j)).numChildren > 0)
					{
						var tmpPiece:Piece = Piece(GridItem(GridRow(board.getChildAt(i)).getChildAt(j)).getChildAt(0));
						if (tmpPiece.color != this.color && tmpPiece.canMove(board,BoardSquare(this.parent)))
						{
							this.checker = tmpPiece;
							return tmpPiece;
						}
					}
				}
			}
			
			return null;
		}
		
		public function showCheck(bool:Boolean):void
		{
				this.setStyle("resizeEffect",(bool==true ? "check" : "uncheck"));
				this.dispatchEvent(new Event("resize"));
				this.setStyle("resizeEffect",null);
		}
	}
}