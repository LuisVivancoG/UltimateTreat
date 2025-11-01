using TMPro;
using UnityEngine;

public class PlayAgainDialog : DialogBase
{
    [SerializeField] private TMP_Text _titleText;
    [SerializeField] private TMP_Text _descriptionText;
    [SerializeField] private TMP_Text _acceptButtonText;
    [SerializeField] private TMP_Text _cancelButtonText;
    public override Menus MenuType()
    {
        return Menus.PlayAgain;
    }
    public void Show(string title, string description, string acceptButtonText, string cancelButtonText/*, Action<PlacedBuildingBase> dismantle, Action upgrade, PlacedBuildingBase building*/)
    {
        _titleText.text = title;
        _descriptionText.text = description;
        _acceptButtonText.text = acceptButtonText;
        _cancelButtonText.text = cancelButtonText;
    }

    public void ButtonAccept()
    {
        _manager.HideDialog(MenuType());
        //AudioManager.Instance.UISound(AudioManager.UIType.Accept);
    }
    public void ButtonCancel()
    {
        _manager.HideDialog(MenuType());
        //AudioManager.Instance.UISound(AudioManager.UIType.Reject);
    }
}
