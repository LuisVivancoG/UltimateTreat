using UnityEngine;

public class CollisionSound : MonoBehaviour
{
    [SerializeField] private TypeOfSound _typeOfSound;

    private void OnCollisionEnter(Collision collision)
    {
        AudioManager.PlaySound(_typeOfSound);
    }
}
