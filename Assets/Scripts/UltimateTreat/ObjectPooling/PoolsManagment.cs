using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class PoolsManagment : Singleton<PoolsManagment>
{
    [SerializeField] private GameObject _poolsGrp;
    [SerializeField] private AllPOData _pObjectsData;
    public AllPOData POData => _pObjectsData;
    internal Dictionary<SOType, PoolBase> _poolsDictionary;

    private void Start()
    {
        InitializePool();
    }

    void InitializePool()
    {
        _poolsDictionary = new(); //Initialize pools
        foreach (SOType type in Enum.GetValues(typeof(SOType))) //Adds a pool for each SOType in the _poolsDictionary
        {
            _poolsDictionary.Add(type, new PoolBase(() => CreatePoolObjectType(type), GetObjectFromPool, ReturnObjectToPool));
        }
    }

    private PooledAsset CreatePoolObjectType(SOType itemType) //Method to create an object of SOType requested from their respected pool
    {
        SOData dataToUse = GetObjectData(itemType);
        PooledAsset newPooledItem;
        newPooledItem = Instantiate(dataToUse.ObjectPrefab, _poolsGrp.transform);
        newPooledItem.SetPoolManager(this);

        return newPooledItem;
    }
    private void GetObjectFromPool(PooledAsset item) //Enable object from type requested
    {
        item.gameObject.SetActive(true);
    }
    private void ReturnObjectToPool(PooledAsset item) //Disable object from type requested
    {
        item.gameObject.SetActive(false);
    }

    private SOData GetObjectData(SOType itemType) //Method that returns data from SOType requested
    {
        return POData.Data.FirstOrDefault(b => b.ObjectType == itemType);
    }

    public PooledAsset GetObject(SOType type, Transform spawner)
    {
        _poolsDictionary.TryGetValue(type, out PoolBase pool);
        var item = _poolsDictionary[type].Get();

        item.transform.position = spawner.position;
        item.transform.rotation = Quaternion.LookRotation(spawner.forward, Vector3.up);

        return item;
    }
    public PooledAsset GetObject(SOType type, Vector3 locationToSpawn, Vector3 spawnedRotation)
    {
        _poolsDictionary.TryGetValue(type, out PoolBase pool);
        var item = _poolsDictionary[type].Get();

        item.transform.localEulerAngles = spawnedRotation;
        item.transform.position = locationToSpawn;

        return item;
    }

    public void RemoveObject(PooledAsset objectToRemove)
    {
        objectToRemove.gameObject.SetActive(false);
        _poolsDictionary[objectToRemove.SOData.ObjectType].Release(objectToRemove);
    }
}
