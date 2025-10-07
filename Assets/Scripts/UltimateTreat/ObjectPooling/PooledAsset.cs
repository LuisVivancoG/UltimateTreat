using UnityEngine;

public class PooledAsset : MonoBehaviour
{
    [SerializeField] private SOData _sOData;
    public SOData SOData => _sOData;
    private PoolsManagment _manager;

    /*private void OnCollisionEnter(Collision collision)
    {
        AudioManager.PlaySound(TypeOfSound.Explosion);
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
