using System;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;

public class ConfirmationDialog : DialogBase
{
    [SerializeField] private TMP_Text _titleText;
    [SerializeField] private TMP_Text _descriptionText;
    [SerializeField] private TMP_Text _acceptButtonText;
    [SerializeField] private TMP_Text _cancelButtonText;
    private Action _onConfirm;
    private Action _onCancel;
    /*private Action<PlacedBuildingBase> _onDismantle;
    private PlacedBuildingBase _building;*/
    //[SerializeField] private Button _acceptButton;

    public override Menus MenuType()
    {
        return Menus.ConfirmationDialog;
    }

    public void Show(string title, string description, string acceptButtonText, string cancelButtonText, Action actionConfirmed/*, Action actionCanceled*/)
    {
        _titleText.text = title;
        _descriptionText.text = description;
        _acceptButtonText.text = acceptButtonText;
        _cancelButtonText.text = cancelButtonText;

        _onConfirm = actionConfirmed;
        //_onCancel = actionCanceled;
    }

    public void ButtonAccept()
    {
        _onConfirm?.Invoke();
        //_building.ToggleCanvas();
        _manager.HideDialog(MenuType());
        //AudioManager.Instance.UISound(AudioManager.UIType.Accept);
    }
    public void ButtonCancel()
    {
        _manager.HideDialog(MenuType());
        //_onCancel?.Invoke();
    }
}
