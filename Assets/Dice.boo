import UnityEngine

enum DiceState: 
	Appear
	Normal
	Rolling
	Vanish
		
class Dice (MonoBehaviour):
	public state as DiceState = DiceState.Normal
	public currentPosition as Vector3
	public currentRotation as Quaternion
	private owner as Aqui
	private moves = []
	private rollingDirection = Direction.None
	private scale as single
	
	State:
		get:
			return self.state

	def Start ():
		field = GameObject.FindWithTag("Field")
		self.scale = Setting.DICE_SIZE
			
	def Update ():
		if self.state == DiceState.Rolling and self.rollingDirection != Direction.None:
			collider.enabled = false
			self.owner.transform.position.x = self.transform.position.x
			self.owner.transform.position.z = self.transform.position.z
			Rotate(self.rollingDirection)
			CheckEndRotate()
		else:
			collider.enabled = true
		
	def StartRotate(direction as Direction):
		self.state = DiceState.Rolling
		self.currentPosition = self.transform.position
		self.currentRotation = self.transform.rotation
		self.rollingDirection = direction

	def Rotate(direction as Direction):
		self.Rotate(direction, 0.3)
			
	def Rotate(direction as Direction, delay as single):
	"""
	Rotate dice to 'direction' in 'delay'.
		@params Direction direction
		@params single delay
	"""
		axis = def():
			if direction == Direction.Up or direction == Direction.Down:
				return Vector3.right
			return Vector3.forward
		pole = def():
			if direction == Direction.Up:
				return Vector3.forward
			elif direction == Direction.Down:
				return Vector3.forward * -1
			elif direction == Direction.Left:
				return Vector3.right * -1
			elif direction == Direction.Right:
				return Vector3.right
		angle = def():
			if direction == Direction.Down or direction == Direction.Right:
				return -1
			return 1
		vector as Vector3 = self.currentPosition + (pole() + Vector3.up * -1) * scale
		self.transform.RotateAround(vector, axis(),  angle() * (90 / delay) * Time.deltaTime)

	def CheckEndRotate():
		if not self.state == DiceState.Rolling: return
		dotFwd as single = Vector3.Dot(transform.forward, Vector3.up)
		dotRight as single = Vector3.Dot(transform.right, Vector3.up)
		dotUp as single = Vector3.Dot(transform.up, Vector3.up)
		next as Vector3 = self.NextPosition(self.currentPosition, self.rollingDirection)
		distance as single = Vector3.Distance(next, self.transform.position)
		if Mathf.Abs(dotFwd) > 0.999 or Mathf.Abs(dotRight) > 0.999 or Mathf.Abs(dotUp) > 0.999 and distance < scale * 0.1:
			self.transform.position = next
			self.transform.rotation = self.Horizontal(self.transform.rotation)
			self.state = DiceState.Normal
			self.rollingDirection = Direction.None
			owner.SendMessage("EndRolling")
			
	def SetOwner(player as Aqui):
		self.owner = player

	def NextPosition(current as Vector3, direction as Direction):
		return self.DirectionToVector3(direction) * scale * 2 + current
			
	def Horizontal(rotation as Quaternion) as Quaternion:
		eulerAngle as Vector3 = Vector3.zero
		eulerAngle.x = Mathf.Round(rotation.eulerAngles.x / 90) * 90
		eulerAngle.y = Mathf.Round(rotation.eulerAngles.y / 90) * 90
		eulerAngle.z = Mathf.Round(rotation.eulerAngles.z / 90) * 90
		quaternion as Quaternion = Quaternion.identity
		quaternion.eulerAngles = eulerAngle
		return quaternion
				
	def DirectionToVector3(direction as Direction) as Vector3:
		if direction == Direction.Up:
			return Vector3.forward
		elif direction == Direction.Down:
			return Vector3.forward * -1
		elif direction == Direction.Left:
			return Vector3.right * -1
		elif direction == Direction.Right:
			return Vector3.right
			
	def UpSide():
		dotFwd as single = Vector3.Dot(transform.forward, Vector3.up)
		dotRight as single = Vector3.Dot(transform.right, Vector3.up)
		dotUp as single = Vector3.Dot(transform.up, Vector3.up)
		if dotFwd > 0.99:
			return 1
		elif dotFwd < -0.99:
			return 6
		if dotRight > 0.99:
			return 4
		elif dotRight < -0.99:
			return 3
		if dotUp > 0.99:
			return 5
		elif dotUp < -0.99:
			return 2
		return 0
		
	static def PositionToMatrix(global as Vector3) as Vector2:
		size = Setting.DICE_SIZE * 2
		x as single = Mathf.Round(global.x / size) + Mathf.Floor(Setting.WIDTH / 2) 
		y as single = Mathf.Round(global.z / size) + Mathf.Floor(Setting.HEIGHT / 2)
		return Vector2(x, y)
		
	def CanRolling(direction as Direction):
		field as Field = FindObjectOfType(Field) as Field
		next = field.GetDice(Field.MatrixByDirection(self.Matrix(), direction))
		return not next
		
	def Matrix():
		return self.PositionToMatrix(self.transform.position)