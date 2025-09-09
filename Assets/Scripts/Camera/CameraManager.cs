using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraManager : MonoBehaviour
{
    [SerializeField] private Camera _camP1;
    [SerializeField] private Camera _camP2;
    [SerializeField] private Transform _p1;
    [SerializeField] private Transform _p2;

    [SerializeField] private float _maxDistance = 10f;

    void Update()
    {
        float distance = Vector3.Distance(_p1.position, _p2.position);

        if (distance > _maxDistance)
        {
            SetSplitScreen();
        }
        else
        {
            SetSingleScreen();
        }
    }

    void SetSplitScreen()
    {
        _camP1.rect = new Rect(0, 0, 0.5f, 1);
        _camP2.rect = new Rect(0.5f, 0, 0.5f, 1);
    }

    void SetSingleScreen()
    {
        _camP1.rect = new Rect(0, 0, 1, 1);
        _camP2.rect = new Rect(0, 0, 0, 0);
    }
}
