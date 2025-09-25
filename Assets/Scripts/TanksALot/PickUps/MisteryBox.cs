using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MisteryBox : MonoBehaviour
{
    private PoolsManager _poolsM;

    private void OnEnable()
    {
        //AudioManager.PlaySound(TypeOfSound.SpawningBlock);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Players"))
        {
            var player = collision.collider.GetComponent<TankShooting>();
            if (player != null)
            {
                if (!player._hasPowerUp)
                {
                    int i = UnityEngine.Random.Range(0, _poolsM.ItemsData.Data.Length-1);
                    Debug.Log(_poolsM.ItemsData.Data[i]);
                    player.SetAbility(_poolsM.ItemsData.Data[i]);
                   
                }
                else Debug.Log("Player already has " + player._ability);
            }
            gameObject.SetActive(false);
        }
    }

    public void SetUp(PoolsManager PManager)
    {
        _poolsM = PManager;
    }
}
