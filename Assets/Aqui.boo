import UnityEngine

enum PlayerState:
	Normal
	Rolling
	Death

class Aqui (MonoBehaviour): 
	
	public currentDice as GameObject
	private state as PlayerState
	private wall as GameObject
	
	def Start ():
		wall = GameObject.Find("Wall")
					
	def Update ():
		if self.currentDice:
			dice as Dice = self.currentDice.GetComponent[of Dice]()
			v = Field.MatrixToPosition(dice.Matrix())
			wall.transform.position = v + Vector3.up * Setting.DICE_SIZE
			
	def OnGround(otherObject as Collider):
		if otherObject.gameObject.tag == "Dice":
			self.currentDice = otherObject.gameObject
			
	def OnOutGround(otherObject as Collider):
		if otherObject.gameObject == self.currentDice and self.state == PlayerState.Normal:
			self.currentDice = null
		
	def OnControllerColliderHit(hit as ControllerColliderHit):
		obj as GameObject = hit.gameObject
		if obj.tag == "Wall" and self.state == PlayerState.Normal:
			obj.SendMessage("RollDice", self)
			
	def StartRolling(wall as Wall):
		self.state = PlayerState.Rolling
		self.ToggleControl(false)
			
	def EndRolling():
		self.state = PlayerState.Normal
		self.ToggleControl(true)
		self.CheckVanishDice()	

	def ToggleControl(toggle as bool):
		self.GetComponent[of CharacterMotor]().canControl = toggle
		collider.enabled = toggle
		self.GetComponent[of CharacterController]().enabled = toggle
		
	def CheckVanishDice():
		dice as Dice = self.currentDice.GetComponent[of Dice]()
		position as Vector2 = dice.Matrix()
		field as Field = GameObject.FindWithTag("Field").GetComponent[of Field]()
		list = field.GetNeighborList(position)
		upside = dice.UpSide()
		if upside != 1 and len(list) >= upside:
			for position as Vector2 in list:
				dice = field.GetDice(position).GetComponent[of Dice]()
				dice.StartVanish()