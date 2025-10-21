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
            //Debug.LogWarning($"Pool initialized: {type} || current dictionary: {_poolsDictionary.Keys}");
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

    public PooledAsset GetObject(SOType type, Vector3 locationToSpawn)
    {
        if(_poolsDictionary.TryGetValue(type, out PoolBase pool))
        {
            var item = pool.Get();

            item.transform.position = locationToSpawn;

            return item;
        }
        Debug.LogError($"{type} not found in {_poolsDictionary}");
        return null;
    }
    public PooledAsset GetObject(SOType type, Vector3 locationToSpawn, Vector3 spawnedRotation)
    {
        if(_poolsDictionary.TryGetValue(type, out PoolBase pool))
        {
            var item = pool.Get();

            item.transform.localEulerAngles = spawnedRotation;
            item.transform.position = locationToSpawn;

            return item;
        }
        Debug.LogError($"{type} not found in {_poolsDictionary}" +
            $"Dictionary pools: {_poolsDictionary.Keys}");
        return null;
    }

    public void RemoveObject(PooledAsset objectToRemove)
    {
        _poolsDictionary[objectToRemove.SOData.ObjectType].Release(objectToRemove);
        objectToRemove.gameObject.SetActive(false);
    }
}
