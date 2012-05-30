import UnityEngine

class Sensor (MonoBehaviour): 
	defaultPosition as Vector3

	def Start ():
		self.defaultPosition = self.transform.localPosition
	
	def Update ():
		self.transform.localPosition = defaultPosition
