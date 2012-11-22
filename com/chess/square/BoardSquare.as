package com.chess.square
{
	import com.chess.piece.Piece;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;

	public class BoardSquare extends GridItem
	{
		public var Coordinates:int;
		public var HCoordinate:String;
		public var VCoordinate:String;
		
		public function BoardSquare(H:String,V:String)
		{
			super();
			this.HCoordinate = H;
			this.VCoordinate = V;
			this.id = H + V;
			this.styleName = "case";
			this.toolTip = this.id;
			this.width = 50;
			this.height = 50;
			this.name = this.id
		}

		public function isCheck(board:Grid,color:String):Piece
		{
			for(var i:int = 0 ; i < 8 ; i++)
			{
				for (var j:int = 0 ; j < 8 ; j++)
				{
					if (GridItem(GridRow(board.getChildAt(i)).getChildAt(j)).numChildren > 0)
					{
						var tmpPiece:Piece = Piece(GridItem(GridRow(board.getChildAt(i)).getChildAt(j)).getChildAt(0));
						if (tmpPiece.color != color && tmpPiece.canMove(board,this))
						{
							tmpPiece.showCheck(false); // on met la pièce en évidence
							return tmpPiece;
						}
					}
				}
			}
			
			return null;
		}
		
	}
}