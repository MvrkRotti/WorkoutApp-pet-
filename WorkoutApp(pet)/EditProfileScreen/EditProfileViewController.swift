//
//  EditProfileViewController.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 23.02.2024.
//

import UIKit
import FirebaseAuth

final class EditProfileViewController: UIViewController {
    
    //MARK: - Variables
    var router: EditProfileScreenRouter?
    
    var viewModel: EditProfileViewModel
    
    private let profilePhoto = ProfilePhotoView(frame: CGRect())
    private let ageTextField = AgeTextField()
    private let weightTextField = WeightTextField()
    private let heightTextField = HeightTextField()
    private let genderSelector = GenderSegmentController(items: ["Female", "Male"])
    private let selectPhotoButton = SelectPhotoButton()
    
    private var isImageSelected = false
    private var imageURL: String?
    private let imagePicker = UIImagePickerController()
    //MARK: - UI Components
    
    private lazy var profileStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ageTextField,weightTextField, heightTextField])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorResources.customDarkGrey
        navigationBarAppearance()
        setupUI()
        setupLayout()
        loadImage()
        imagePicker.delegate = self
        selectPhotoButton.addTarget(self, action: #selector(addPhotoDidTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
}

//MARK: - UI Setup

private extension EditProfileViewController {
    func navigationBarAppearance() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveDidTapped))
        
        navigationItem.title = "Edit profile"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = ColorResources.customDarkGrey
        navigationController?.navigationBar.alpha = 0.9
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func setupUI() {
        view.setupView(profilePhoto)
        view.setupView(profileStack)
        view.setupView(genderSelector)
        view.setupView(selectPhotoButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            profilePhoto.heightAnchor.constraint(equalToConstant: 140),
            profilePhoto.widthAnchor.constraint(equalToConstant: 140),
            profilePhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            ageTextField.heightAnchor.constraint(equalToConstant: 44),
            ageTextField.widthAnchor.constraint(equalToConstant: 334),
            
            weightTextField.heightAnchor.constraint(equalToConstant: 44),
            weightTextField.widthAnchor.constraint(equalToConstant: 334),
            
            heightTextField.heightAnchor.constraint(equalToConstant: 44),
            heightTextField.widthAnchor.constraint(equalToConstant: 334),
            
            profileStack.topAnchor.constraint(equalTo: selectPhotoButton.bottomAnchor, constant: 15),
            profileStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            genderSelector.topAnchor.constraint(equalTo: profileStack.bottomAnchor, constant: 15),
            genderSelector.widthAnchor.constraint(equalTo: profileStack.widthAnchor),
            genderSelector.heightAnchor.constraint(equalToConstant: 44),
            genderSelector.centerXAnchor.constraint(equalTo: profileStack.centerXAnchor),
            
            selectPhotoButton.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 5),
            selectPhotoButton.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor)
        ])
    }
    
    @objc func saveDidTapped() {
        guard let ageText = ageTextField.text, let age = Int(ageText),
              let weightText = weightTextField.text, let weight = Double(weightText),
              let heightText = heightTextField.text, let height = Double(heightText) else { return }
        
        let genderIndex = genderSelector.selectedSegmentIndex
        let gender = genderIndex == 0 ? "Female" : "Male"
                
        guard let userID = Auth.auth().currentUser?.uid else {
            return showAlert(message: "You should be authorised user!")
        }
        
        viewModel.saveUserData(age: age, weight: weight, height: height, gender: gender, userID: userID)
        
        router?.navigateBack()        
    }
}


extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @objc func addPhotoDidTapped() {
        if !isImageSelected { // Проверяем, выбрано ли уже изображение
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image selected")
            return
        }
        
        // Загрузка изображения в Firebase Storage
        viewModel.uploadImage(image: image) { [weak self] imageURL in
            guard let imageURL = imageURL else { return }
            self?.viewModel.saveImageURL(imageURL) // Сохранение URL загруженного изображения
            self?.updateImageView(with: imageURL)
        }
    }
    
    func updateImageView(with imageURL: String) {
        guard let url = URL(string: imageURL) else {
            print("Invalid URL")
            return
        }
        // Загрузка изображения из URL
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    let scaledImage = ImageScaler.scaleImage(image, toFit: self?.profilePhoto.bounds.size ?? CGSize.zero)
                    self?.profilePhoto.image = scaledImage
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func loadImage() {
        if let savedImageURL = UserDefaults.standard.string(forKey: "imageURL") {
            imageURL = savedImageURL
            updateImageView(with: savedImageURL)
        }
    }
}
