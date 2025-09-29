using System.Collections;
using Unity.AI.Navigation;
using UnityEngine;
using UnityEngine.AI;

public class CratesManager : Singleton<CratesManager>
{
    [SerializeField] private float _minTimer = 1f;
    [SerializeField] private float _maxTimer = 5f;

    [SerializeField] private NavMeshSurface _surface;

    private void Start()
    {
        Bounds bounds = _surface.navMeshData.sourceBounds;
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
        // Get triangulation data from the current NavMesh
        NavMeshTriangulation triangulation = NavMesh.CalculateTriangulation();

        // Pick a random triangle
        int triangleIndex = Random.Range(0, triangulation.indices.Length / 3) * 3;

        Vector3 vert1 = triangulation.vertices[triangulation.indices[triangleIndex]];
        Vector3 vert2 = triangulation.vertices[triangulation.indices[triangleIndex + 1]];
        Vector3 vert3 = triangulation.vertices[triangulation.indices[triangleIndex + 2]];

        // Pick a random point inside this triangle using barycentric coordinates
        Vector3 randomPoint = RandomPointInTriangle(vert1, vert2, vert3);

        // (Optional) validate with SamplePosition in case of precision issues
        if (NavMesh.SamplePosition(randomPoint, out NavMeshHit hit, 1f, NavMesh.AllAreas))
        {
            PoolsManagment.Instance.GetObject(SOType.Crate, randomPoint, new Vector3 ());
        }

        StartCoroutine(CratesSpawning());
    }
    // Utility: Generate random point inside a triangle
    private Vector3 RandomPointInTriangle(Vector3 a, Vector3 b, Vector3 c)
    {
        float r1 = Random.value;
        float r2 = Random.value;

        // Ensure uniform distribution inside the triangle
        if (r1 + r2 > 1f)
        {
            r1 = 1f - r1;
            r2 = 1f - r2;
        }

        return a + r1 * (b - a) + r2 * (c - a);
    }
}
