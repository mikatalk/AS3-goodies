package
{
	public class ListCellVO
	{
		public var id:int, ref:String, title:String, price:int, purchased:Boolean;
		public function ListCellVO(id:int, ref:String, title:String, price:int, purchased:Boolean)
		{
			this.id = id;
			this.ref = ref;
			this.title = title;
			this.price = price;
			this.purchased = purchased;
		}
	}
}