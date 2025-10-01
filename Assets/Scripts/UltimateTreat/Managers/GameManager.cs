using System.Collections.Generic;
using Unity.AI.Navigation;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.AI;

public class GameManager : Singleton<GameManager>
{
    [SerializeField] public List<PlayerController> _currentPlayers;
    [SerializeField] private CinemachineTargetGroup _targetGroup;

    [SerializeField] private CratesManager _spawnerManager;
    [SerializeField] private NavMeshSurface _levelSruface;

    private void Start()
    {
        Bounds bounds = _levelSruface.navMeshData.sourceBounds;
        //_currentPlayers = new List<PlayerController>();
        //SetUpPlayers();
        _spawnerManager.SetSurface(_levelSruface);
    }

    public void SetUpPlayers()
    {
        int tempID = 0;

        foreach (var player in _currentPlayers)
        {
            tempID++;

            player.SetUpPlayer(tempID);
            player._playerHealth.SetHP(tempID, 200);
            _targetGroup.AddMember(player.gameObject.transform, 1f, 1f);
        }

        PlacePlayers();
        //SetPlayersHealth();
    }

    void PlacePlayers()
    {
        foreach (var player in _currentPlayers)
        {
            NavMeshTriangulation triangulation = NavMesh.CalculateTriangulation();


            int triangleIndex = Random.Range(0, triangulation.indices.Length / 3) * 3;

            Vector3 vert1 = triangulation.vertices[triangulation.indices[triangleIndex]];
            Vector3 vert2 = triangulation.vertices[triangulation.indices[triangleIndex + 1]];
            Vector3 vert3 = triangulation.vertices[triangulation.indices[triangleIndex + 2]];

            Vector3 randomPoint = RandomPointInTriangle(vert1, vert2, vert3);

            if (NavMesh.SamplePosition(randomPoint, out NavMeshHit hit, 1f, NavMesh.AllAreas))
            {
                player.transform.position = hit.position;
            }
        }
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
    }

    /*void SetPlayersHealth()
    {
        foreach (var player in _currentPlayers)
        {
            player._playerHealth.SetHP(200);
        }
    }*/
}
