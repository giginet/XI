import UnityEngine

class Field (MonoBehaviour):
	public dicePrefab as GameObject 
	private field as System.Collections.Hashtable
	private popCount = 0

	def Start ():
		self.transform.localScale.z = Setting.WIDTH * 10
		self.transform.localScale.x = Setting.HEIGHT * 10
		self.field = {}
		PopDice(Vector2(Mathf.Floor(Setting.WIDTH / 2), Mathf.Floor(Setting.HEIGHT / 2)), false)
		for a in range(Mathf.Floor(5 + Random.value * 5)):
			PopDice(false)
		
	def Update ():
		self.LotPopDice()

	def GetDice(position as Vector2) as GameObject:
		if self.IsExist(position):
			return  self.field[position] as GameObject
		return null
		
	def SetDiceWithPosition(dice, position as Vector2):
		if not self.IsExist(position):
			self.field.Add(position, dice)
	
	def SetDice(dice as Dice):
		self.SetDiceWithPosition(dice, dice.Matrix())
	
	def IsExist(position as Vector2) as bool:
		if position.x < 0 or position.x >= Setting.WIDTH or position.y < 0 or position.y >= Setting.HEIGHT: return false
		return self.field.Contains(position)
	
	def MoveDice(src as Vector2, dst as Vector2):
		if self.IsExist(src) and not self.IsExist(dst):
			dice = self.GetDice(src)
			self.SetDiceWithPosition(dice, dst)
			self.field.Remove(src)
			
	def RemoveDice(position as Vector2):
		dice = self.GetDice(position)
		self.field.Remove(position)
		Destroy(dice)
		
	def PopDice(animation as bool):
		x = Mathf.Floor(Random.value * Setting.WIDTH)
		y = Mathf.Floor(Random.value * Setting.HEIGHT) 
		return PopDice(Vector2(x, y), animation)
			
	def PopDice(position as Vector2, animation as bool):
		if not self.IsExist(position):
			list = array([Mathf.Floor(Random.value * 4) * 90 for i in range(3)])
			q = Quaternion.identity
			q.eulerAngles = Vector3(list[0], list[1], list[2])
			v = self.MatrixToPosition(position)
			if animation:
				v.y = Setting.DICE_SIZE * -1
			obj = Instantiate(dicePrefab, v, q) as GameObject
			self.SetDiceWithPosition(obj, position)
			dice = obj.GetComponent[of Dice]()
			dice.state = DiceState.Appear
			return obj
		return null
				
	def LotPopDice():
		if popCount % 300 == 0:
			self.PopDice(true)
		++popCount
		
	static def MatrixToPosition(position as Vector2) as Vector3:
		x = Setting.DICE_SIZE * 2 * (position.x - Mathf.Floor(Setting.WIDTH / 2))
		z = Setting.DICE_SIZE * 2 * (position.y - Mathf.Floor(Setting.HEIGHT / 2))
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
		return Vector2(x, y)
		
	def GetNeighborList(position as Vector2) as List:
		/*
			Returns the list contains neighbor same number dices.
			@params Vector2 position The check will start from this point on Field.
			@return list of dices. If no dices will vanish, returns empty list.
		**/
		if not self.IsExist(position): return
		checkedList = []
		return self.CheckNeighbor(position, checkedList)
			
	def CheckNeighbor(position as Vector2, checkedList as List) as List:
		vanish = []
		directions = [Direction.Up, Direction.Left, Direction.Down, Direction.Right]
		dice as Dice = self.GetDice(position).GetComponent[of Dice]()
		if not checkedList.Contains(position):
			checkedList.Add(position)
			vanish.Add(position)
			for direction as Direction in directions:
				next = Field.MatrixByDirection(position, direction)
				if not self.IsExist(next): continue
				nextDice as Dice = self.GetDice(next).GetComponent[of Dice]()
				if dice.CanVanishWith(nextDice):
					vanish += CheckNeighbor(next, checkedList)
		return vanish
		
	static def IsOffField(position as Vector2):
		return position.x < 0 or position.y < 0 or position.x >= Setting.WIDTH or position.y >= Setting.HEIGHT