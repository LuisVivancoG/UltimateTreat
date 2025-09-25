using UnityEngine;

public class PooledAsset : MonoBehaviour
{
    [SerializeField] private SOData _sOData;
    public SOData SOData => _sOData;
    private PoolsManagment _manager;

    /*private void OnCollisionEnter(Collision collision)
    {
        AudioManager.PlaySound(TypeOfSound.Explosion);

        if (collision.gameObject.layer != 8)
        {
            returnItem();
        }

        else if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Players"))
        {
            var player = collision.collider.GetComponent<HealthManager>();
            if (player != null)
            {
                player.DoDamage(_itemData.HPModifier);
            }
        }
    }*/

    internal void SetPoolManager(PoolsManagment poolsManager)
    {
        _manager = poolsManager;
    }

    public void returnItem()
    {
        _manager.RemoveObject(this);
    }
}
