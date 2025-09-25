using System;
using UnityEngine;

public class ItemBase : MonoBehaviour
{
    [SerializeField] private ItemData _scriptedObjectData;
    public ItemData _itemData => _scriptedObjectData;
    private PoolsManager _poolsManager;

    public static ItemBase instance;

    private void Awake()
    {
        instance = this;
    }

    private void OnCollisionEnter(Collision collision)
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
    }

    internal void SetPoolManager(PoolsManager poolsManager)
    {
        _poolsManager = poolsManager;
    }

    public void returnItem()
    {
        _poolsManager.RemoveItem(this);
    }
}
