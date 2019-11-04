defmodule Takta.Annotations do
  @moduledoc false
  use Takta.Query
  alias Takta.Annotations.{Annotation, AnnotationForms}

  def all, do: Repo.all(Annotation)

  def find_by_id(aid) do
    Repo.one(from a in Annotation, where: a.id == ^aid)
  end

  def create(params) do
    %Annotation{}
    |> AnnotationForms.new(params)
    |> Repo.insert()
  end

  def update(%Annotation{} = annotation, params) do
    annotation
    |> AnnotationForms.update(params)
    |> Repo.update()
  end

  def delete(aid) do
    case find_by_id(aid) do
      nil -> {:error, :not_found}
      annotation -> annotation |> Repo.delete()
    end
  end
end
