using System.Collections;
using System.Collections.Generic;
using Unity.AI.Navigation;
using UnityEngine;
using UnityEngine.AI;

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
    [SerializeField] private Vector2 _spawnableArea = new Vector2(50f, 50f);
    [SerializeField] private float _spawnHeight = 20f;
    [SerializeField] private LayerMask _groundMask;
    [SerializeField] private LayerMask _obstaclesMask;
    [SerializeField] private string _groundTag = "Ground";

    [Header("Crates")]
    [SerializeField] private GameObject _cratePrefab;
    [SerializeField] private float _minDistanceCrates = 1.5f;
    [SerializeField] private int _maxAttempts = 20;

    private List<Vector3> _spawnedPositions = new List<Vector3>();

    public void StartSpawningCrates()
    {
        for (int i = 0; i < _maxAttempts; i++)
        {
            Vector3 randomXZ = new Vector3(
                Random.Range(-_spawnableArea.x / 2f, _spawnableArea.x / 2f),
                0f,
                Random.Range(-_spawnableArea.y / 2f, _spawnableArea.y / 2f)
            );

            Vector3 rayOrigin = transform.position + randomXZ;

            rayOrigin.y = transform.position.y;

            if (Physics.Raycast(rayOrigin, Vector3.down, out RaycastHit hit, _spawnHeight, _groundMask))
            {
                if (!hit.collider.CompareTag(_groundTag))
                    continue;

                if (Physics.CheckSphere(hit.point, 0.5f, _obstaclesMask))
                    continue;

                if (TooCloseToOthers(hit.point))
                    continue;

                //PoolsManagment.Instance.GetObject(SOType.Crate, hit.point, transform.rotation.eulerAngles);
                Instantiate(_cratePrefab, hit.point, Quaternion.identity);
                _spawnedPositions.Add(hit.point);
                return;
            }
        }

        Debug.LogWarning("No valid spawn position found after multiple attempts.");
    }
    private bool TooCloseToOthers(Vector3 pos)
    {
        foreach (var p in _spawnedPositions)
        {
            if (Vector3.Distance(p, pos) < _minDistanceCrates)
                return true;
        }
        return false;
    }

#if UNITY_EDITOR
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        //_spawnableArea.y = transform.position.y;
        Vector3 center = transform.position - new Vector3(0, _spawnHeight / 2f, 0);
        Vector3 size = new Vector3(_spawnableArea.x, _spawnHeight, _spawnableArea.y);

        Gizmos.DrawWireCube(center, size);

        Gizmos.color = Color.yellow;
        foreach (var p in _spawnedPositions)
        {
            Gizmos.DrawSphere(p, 0.2f);
        }
    }
#endif
}
