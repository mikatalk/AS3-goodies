package
{
	/** simple email validation prior to server valiation */
	public function validateEmail(email:String):Boolean
	{
		var emailExpression:RegExp=/^[a-z0-9][-._a-z0-9]*@([a-z0-9][-_a-z0-9]*\.)+[a-z]{2,6}$/;
		return emailExpression.test(email);
	}
}
