using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;

public class CratesManager : Singleton<CratesManager>
{
    /*[SerializeField] private float _minTimer = 1f;
    [SerializeField] private float _maxTimer = 5f;
    
    private NavMeshSurface _surface;

    public void SetSurface(NavMeshSurface navMesh)
    {
        _surface = navMesh;
        StartCoroutine(CratesSpawning());
    }

    private IEnumerator CratesSpawning()
    {
        //PoolsManagment.Instance.GetObject(SOType.Crate);
        yield return new WaitForSeconds(Cooldown());
        SpawnOnNavMesh();
    }

    private float Cooldown()
    {
        return Random.Range(_minTimer, _maxTimer);
    }

    void SpawnOnNavMesh()
    {
        NavMeshTriangulation triangulation = NavMesh.CalculateTriangulation();


        int triangleIndex = Random.Range(0, triangulation.indices.Length / 3) * 3;

        Vector3 vert1 = triangulation.vertices[triangulation.indices[triangleIndex]];
        Vector3 vert2 = triangulation.vertices[triangulation.indices[triangleIndex + 1]];
        Vector3 vert3 = triangulation.vertices[triangulation.indices[triangleIndex + 2]];

        Vector3 randomPoint = RandomPointInTriangle(vert1, vert2, vert3);

        if (NavMesh.SamplePosition(randomPoint, out NavMeshHit hit, 1f, NavMesh.AllAreas))
        {
            PoolsManagment.Instance.GetObject(SOType.Crate, randomPoint, new Vector3 ());
        }

        StartCoroutine(CratesSpawning());
    }

    private Vector3 RandomPointInTriangle(Vector3 a, Vector3 b, Vector3 c)
    {
        float r1 = Random.value;
        float r2 = Random.value;

        if (r1 + r2 > 1f)
        {
            r1 = 1f - r1;
            r2 = 1f - r2;
        }

        return a + r1 * (b - a) + r2 * (c - a);
    }*/
    [Header("Spawn Settings")]
    [SerializeField] private Vector3 _spawnableArea = new Vector3(50f, 50f, 50f);
    [SerializeField] private LayerMask _groundMask;
    [SerializeField] private float _frequencyTime = 5f;

    private float _currentFrequency;
    private Vector3 _spawnOrigin;
    private float _yMin;
    private float _yMax;
    //private List<Vector3> _spawnedPositions;

    private void Start()
    {
        _yMax = transform.position.y;
        _yMin = transform.position.y - _spawnableArea.y;
        _currentFrequency = _frequencyTime;
        //_spawnedPositions = new List<Vector3>();
    }

    public void SpawnCrates()
    {
        var crate = PoolsManagment.Instance.GetObject(SOType.Crate, GetLocationInBoundBox());
        //_spawnedPositions.Add(crate.transform.position);
        StartCoroutine(Cooldown());
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

        Debug.LogError($"Location not found within bound box {hit.point}");
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
