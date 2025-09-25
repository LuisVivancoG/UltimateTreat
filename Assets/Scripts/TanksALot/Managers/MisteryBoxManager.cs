using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MisteryBoxManager : MonoBehaviour
{
    [SerializeField] private List<Transform> _locationsSpawners;
    [SerializeField] private MisteryBox _misteryBoxPrefab;
    [SerializeField] private float _newBoxTimer;
    private Dictionary<Transform, MisteryBox> _boxesInGame;
    private List<MisteryBox> _inactiveBoxes;
    private PoolsManager _poolsM;
    private bool _spawningBoxes;
    private void InitializePool()
    {
        _boxesInGame = new ();
        foreach (var loc in _locationsSpawners)
        {
            var box = Instantiate(_misteryBoxPrefab, loc.position, Quaternion.identity, loc.transform);
            box.gameObject.SetActive(false);
            box.SetUp(_poolsM);
            _boxesInGame.Add(loc, box);
        }
    }

    private void PoolBox()
    {
        _inactiveBoxes = new(); //restart _inactiveBoxes list
        foreach (var pair in _boxesInGame) //loop through dictionary elements
        {
            if (!pair.Value.gameObject.activeSelf) //if an element is disabled add it to _inactiveBoxes list
            {
                _inactiveBoxes.Add(pair.Value);
            }
        }

        if (_inactiveBoxes.Count == 0)
        {
            _spawningBoxes = false;
            return;
        }
        else
        {
            int i = UnityEngine.Random.Range(0, _inactiveBoxes.Count);
            var randomBox = _inactiveBoxes[i]; //if there are boxes disabled in _inactiveBoxes then pick a random index and turn it on
            if(_boxesInGame.ContainsValue(randomBox))
            {
                randomBox.gameObject.SetActive(true);
            }
        }
    }

    IEnumerator SpawnBoxes()
    {
        _spawningBoxes = true;

        while(_spawningBoxes)
        {
            PoolBox();
            if (!_spawningBoxes) break;
            yield return new WaitForSeconds(_newBoxTimer);
        }

        if (!_spawningBoxes) Debug.Log("no boxes available");
    }

    public void SetUp(PoolsManager poolManager)
    {
        _poolsM = poolManager;
        InitializePool();
        StartCoroutine(SpawnBoxes());
    }
}