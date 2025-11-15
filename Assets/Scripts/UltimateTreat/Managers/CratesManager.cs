using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;

public class CratesManager : Singleton<CratesManager>
{
    [Header("Spawn Settings")]
    [SerializeField] private Vector3 _spawnableArea = new Vector3(50f, 50f, 50f);
    [SerializeField] private LayerMask _groundMask;
    [SerializeField] private float _frequencyTime = 5f;

    private float _currentFrequency;
    private Vector3 _spawnOrigin;
    private float _yMin;
    private float _yMax;

    private List<SOType> _pickups = new List<SOType>();
    //private List<Vector3> _spawnedPositions;

    private void Start()
    {
        _pickups.Add(SOType.Chocolate);
        _pickups.Add(SOType.HealPack);
        _pickups.Add(SOType.Cotton);
        _pickups.Add(SOType.Candy);

        _yMax = transform.position.y;
        _yMin = transform.position.y - _spawnableArea.y;
        _currentFrequency = _frequencyTime;
        //_spawnedPositions = new List<Vector3>();
    }

    public void SpawnCrates()
    {
        var crate = PoolsManagment.Instance.GetObject(RandomPickup(), GetLocationInBoundBox());
        //_spawnedPositions.Add(crate.transform.position);
        StartCoroutine(Cooldown());
    }

    SOType RandomPickup()
    {
        var randomNumber = Random.Range(0, _pickups.Count);
        SOType created = _pickups[randomNumber];

        return created;
    }

    public Vector3 GetLocationInBoundBox()
    {
        float rayDistance = _spawnableArea.y;
        Vector3 rayOrigin = new Vector3(transform.position.x + Random.Range(-_spawnableArea.x / 2f, _spawnableArea.x / 2f), transform.position.y, transform.position.z + Random.Range(-_spawnableArea.z / 2f, _spawnableArea.z / 2f));

        if (Physics.Raycast(rayOrigin, Vector3.down, out RaycastHit hit, rayDistance, _groundMask))
        {
            _spawnOrigin = hit.point;
            //_spawnOrigin.y = _yMax;
            return _spawnOrigin;
        }

        //Debug.LogError($"Location not found within bound box {hit.point}");
        _spawnOrigin = Vector3.zero;
        //_spawnOrigin.y = _yMax;
        return _spawnOrigin;
    }

    private float FrequencyCheck()
    {
        return _currentFrequency;
    }

    IEnumerator Cooldown()
    {
        yield return new WaitForSeconds(_frequencyTime);
        SpawnCrates();
    }

#if UNITY_EDITOR
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        var yOffset = transform.position.y - (_spawnableArea.y/2);
        Vector3 center = transform.position;
        center.y = yOffset;

        Gizmos.DrawWireCube(center, _spawnableArea);

        /*Gizmos.color = Color.yellow;
        foreach(var item in _spawnedPositions)
        {
            Gizmos.DrawSphere(item, 1f);
        }*/
    }
#endif
}
