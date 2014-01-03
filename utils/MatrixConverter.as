package
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	/** Credits go to Mike Chambers for explaining Matrixes in a blog post:
	 * http://www.mikechambers.com/blog/2009/09/09/converting-from-a-matrix3d-to-matrix-in-actionscript-3/
	 * Thanks Boss!
	**/
	
	public class MatrixConverter
	{
		public static function matrixToMatrix3D(matrix:Matrix):Matrix3D
		{
			return new Matrix3D( Vector.<Number>([ 
				matrix.a,matrix.c,0,matrix.tx, matrix.b,matrix.d,0,matrix.ty, 0,0,0,0, 0,0,0,0 ]) );
		}
		
		public static function matrix3dToMatrix(matrix3D:Matrix3D):Matrix
		{
			return new Matrix( matrix3D.rawData[0],matrix3D.rawData[1],matrix3D.rawData[3], 
				matrix3D.rawData[4],matrix3D.rawData[5],matrix3D.rawData[7] );
		}
	}
}