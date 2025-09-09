using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    [SerializeField] private Camera _gameCam;
    [SerializeField] private float _dampTime;
    [SerializeField] private float _bufferEdge;
    [SerializeField] private float _minsize;
    private List<GameObject> _targetslist = new();
    private float  _zoomSpeed;
    private Vector3 _velocityPos;
    private Vector3 _resultPos;

    void Update()
    {
        if ( _targetslist.Count > 0)
        {
            Move();
            Zoom();
        }
    }

    private void Move()
    {
        GetAveragePos();
        transform.position = Vector3.SmoothDamp(transform.position, _resultPos, ref _velocityPos, _dampTime);
    }

    private void GetAveragePos()
    {
        Vector3 averagePos = new Vector3();
        int playersAlive = 0;

        for (int i = 0; i < _targetslist.Count; i++)
        {
            if (!_targetslist[i].gameObject.activeSelf)
                continue;
            averagePos += _targetslist[i].transform.position;
            playersAlive++;
        }
        if (playersAlive > 0)
        {
            averagePos /= playersAlive;
        }
        averagePos.y = transform.position.y;
        _resultPos = averagePos;
    }

    private void Zoom()
    {
        float newSize = GetZoom();
        _gameCam.orthographicSize = Mathf.SmoothDamp(_gameCam.orthographicSize, newSize, ref _zoomSpeed, _dampTime);
    }

    private float GetZoom()
    {
        Vector3 localPos = transform.InverseTransformPoint(_resultPos);
        float resultSize = 0f;

        for (int i = 0; i< _targetslist.Count; i++)
        {
            if(!_targetslist[i].gameObject.activeSelf)
                continue;
            Vector3 targetLocalPos = transform.InverseTransformPoint(_targetslist[i].transform.position);
            Vector3 desiredPosToTarget = targetLocalPos - localPos;
            resultSize = Mathf.Max(resultSize, Mathf.Abs(desiredPosToTarget.y));
            resultSize = Mathf.Max(resultSize, MathF.Abs(desiredPosToTarget.x) / _gameCam.aspect);
        }

        resultSize += _bufferEdge;

        resultSize = Mathf.Max(resultSize, _minsize);

        return resultSize;
    }

    public void SetPlayerTarget(GameObject target)
    {
        _targetslist.Add(target);
    }
}
