using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static ItemData;


public class PoolsManager : MonoBehaviour
{
    [SerializeField] private GameObject _poolsGrp;
    [SerializeField] private AllItemsData _itemsData;
    public AllItemsData ItemsData => _itemsData;
    internal Dictionary<ItemType, ItemsPool> _itemsPool;

    internal void InitializePool()
    {
        _itemsPool = new (); //Reset pools
        foreach (ItemType type in Enum.GetValues(typeof(ItemType))) //Adds a pool for each itemType in the _itemsPools
        {
            _itemsPool.Add(type, new ItemsPool(() => CreatePoolItemType(type), GetItemFromPool, ReturnItemToPool));
        }
    }

    private ItemBase CreatePoolItemType(ItemType itemType) //Method to create an item of itemType requested from their respected pool
    {
        ItemData dataToUse = GetItemData(itemType);
        ItemBase newPooledItem;
        newPooledItem = Instantiate(dataToUse.ItemPrefab, _poolsGrp.transform);
        newPooledItem.SetPoolManager(this);

        return newPooledItem;
    }
    private void GetItemFromPool(ItemBase item) //Enable item from item requested
    {
        item.gameObject.SetActive(true);
    }
    private void ReturnItemToPool(ItemBase item) //Disable item from item requested
    {
        item.gameObject.SetActive(false);
    }

    private ItemData GetItemData(ItemType itemType) //Method that returns data from item requested
    {
        return ItemsData.Data.FirstOrDefault(b => b.TypeOfItem == itemType);
    }

    public ItemBase GetItem(ItemData objectToGet, TankShooting player)
    {
        var item = _itemsPool[objectToGet.TypeOfItem].Get();
        item.transform.rotation = player.TurretSpawner.rotation;
        item.transform.position = player.TurretSpawner.position; 

        return item;
    }

    public void RemoveItem(ItemBase objectToRemove)
    {
        objectToRemove.gameObject.SetActive(false);
        _itemsPool[objectToRemove._itemData.TypeOfItem].Release(objectToRemove);
    }
}
