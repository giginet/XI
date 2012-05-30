import UnityEngine

class Field (MonoBehaviour):
	public dicePrefab as GameObject 
	private field as System.Collections.Hashtable

	def Start ():
		self.transform.localScale.z = Setting.WIDTH * 10
		self.transform.localScale.x = Setting.HEIGHT * 10
		self.field = {}
		PopDice(Vector2(5, 5))
		for a in range(10):
			x = Mathf.Floor(Random.value * Setting.WIDTH)
			y = Mathf.Floor(Random.value * Setting.HEIGHT) 
			PopDice(Vector2(x, y))
		
	def Update ():
		pass

	def GetDice(position as Vector2):
		if self.IsExist(position):
			return  self.field[position]
		return null
		
	def SetDiceWithPosition(dice, position as Vector2):
		if not self.IsExist(position):
			self.field.Add(position, dice)
	
	def SetDice(dice as Dice):
		self.SetDiceWithPosition(dice, dice.Matrix())
	
	def IsExist(position as Vector2) as bool:
		return self.field.Contains(position)
	
	def MoveDice(src as Vector2, dst as Vector2):
		if self.IsExist(src) and not self.IsExist(dst):
			dice = self.GetDice(src)
			self.SetDiceWithPosition(dice, dst)
			self.field.Remove(src)
			
	def PopDice(position as Vector2):
		dice = Instantiate(dicePrefab, self.MatrixToPosition(position), Quaternion.identity)
		self.SetDiceWithPosition(dice, position)
		
	def MatrixToPosition(matrix as Vector2) as Vector3:
		x = Setting.DICE_SIZE * 2 * (matrix.x - Mathf.Floor(Setting.WIDTH / 2))
		z = Setting.DICE_SIZE * 2 * (matrix.y - Mathf.Floor(Setting.HEIGHT / 2))
		return Vector3(x, Setting.DICE_SIZE, z)
		
	static def MatrixByDirection(mat as Vector2, direction as Direction):
		x = mat.x
		y = mat.y
		if direction == Direction.Up:
			y += 1
		elif direction == Direction.Down:
			y -= 1
		elif direction == Direction.Right:
			x += 1
		elif direction == Direction.Left:
			x -= 1
		if x >= Setting.WIDTH or y >= Setting.HEIGHT:
			return null
		return Vector2(x, y)
		