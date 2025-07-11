<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTaskRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $rules = [
            'title' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
            'status' => 'required|in:pending,in_progress,completed',
            'priority' => 'required|in:low,medium,high',
            'due_date' => 'nullable|date|after_or_equal:today',
            'user_assignment_type' => 'required|in:existing,new',
        ];

        // Add conditional validation based on assignment type
        if ($this->input('user_assignment_type') === 'existing') {
            $rules['user_id'] = 'required|exists:users,id';
        } elseif ($this->input('user_assignment_type') === 'new') {
            $rules['new_user_name'] = 'required|string|max:255';
            $rules['new_user_email'] = 'required|email|max:255|unique:users,email';
        }

        return $rules;
    }

    /**
     * Get custom error messages for validation rules.
     */
    public function messages(): array
    {
        return [
            'title.required' => 'The task title is required.',
            'title.max' => 'The task title cannot exceed 255 characters.',
            'status.required' => 'Please select a task status.',
            'status.in' => 'The selected status is invalid.',
            'priority.required' => 'Please select a task priority.',
            'priority.in' => 'The selected priority is invalid.',
            'due_date.after_or_equal' => 'The due date cannot be in the past.',
            'user_id.required' => 'Please select a user for the task.',
            'user_id.exists' => 'The selected user does not exist.',
            'new_user_name.required' => 'The user name is required.',
            'new_user_email.required' => 'The user email is required.',
            'new_user_email.email' => 'Please enter a valid email address.',
            'new_user_email.unique' => 'A user with this email already exists.',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     */
    public function attributes(): array
    {
        return [
            'user_id' => 'assigned user',
            'due_date' => 'due date',
        ];
    }
}
