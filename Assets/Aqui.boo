import UnityEngine

enum PlayerState:
	Normal
	Rolling
	Death

class Aqui (MonoBehaviour): 
	
	private currentDice as GameObject
	private state as PlayerState
	
	def Start ():
		pass
					
	def Update ():
		pass
			
	def OnGround(otherObject as Collider):
		pass
		
	def OnOutGround(otherObject as Collider):
		pass
		
	def OnControllerColliderHit(hit as ControllerColliderHit):
		wall as GameObject = hit.gameObject
		if wall.tag == "Wall" and self.state == PlayerState.Normal:
			wall.SendMessage("RollDice", self)
	
	def StartRolling(wall as Wall):
		self.currentDice = wall.gameObject.transform.parent.gameObject
		self.state = PlayerState.Rolling
			
	def EndRolling():
		self.state = PlayerState.Normal
		self.currentDice = null 